//
//  ABSSocketSession.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2025-06-22.
//

import Foundation
import RagnarSocketIO

/// Owns the Audiobookshelf-specific endpoint and authentication lifecycle for a Socket.IO client.
public actor ABSSocketSession {

    // MARK: - Public Types

    /// The current Audiobookshelf application-authentication state.
    public enum AuthState: Sendable, Equatable {
        case unauthenticated
        case authenticating
        case authenticated(
            connectionID: UInt64,
            userID: String,
            username: String
        )
        case failed(message: String)
    }

    // MARK: - Private ABS Server Events

    private struct AuthFailedEvent: SocketEvent {
        static let name = "auth_failed"

        struct Schema: Decodable, Sendable {
            let message: String
        }
    }

    // MARK: - Private State

    private let client: any SocketClient
    private var currentToken: String?
    private var currentServerURL: URL?
    private var isConnected = false
    private var isInvalidated = false
    private var transportConnectionID: UInt64 = 0
    private var authenticatedTransportConnectionID: UInt64?
    private var authenticatedConnectionID: UInt64 = 0
    private var authState: AuthState = .unauthenticated

    private var statusObserverTask: Task<Void, Never>?
    private var initObserverTask: Task<Void, Never>?
    private var initObserverID: UUID?
    private var authFailedObserverTask: Task<Void, Never>?
    private var authFailedObserverID: UUID?
    private var authStateContinuations: [UUID: AsyncStream<AuthState>.Continuation] = [:]

    // MARK: - Init

    /// Creates a session backed by an unconnected Socket.IO client.
    public init(client: any SocketClient) {
        self.client = client
    }

    // MARK: - Public API

    /// Connects to an Audiobookshelf server and authenticates with an access token.
    ///
    /// The server URL may include a RouterBasePath. Endpoint resolution is delegated to
    /// `RagnarSocketIO`. Repeating the URL lets the client preserve its active transport while a
    /// changed token is re-emitted for application authentication.
    public func connect(to serverURL: URL, token: String) async throws {
        await startObservationIfNeeded()

        let previousServerURL = currentServerURL
        let previousToken = currentToken
        let tokenChanged = token != previousToken

        currentServerURL = serverURL
        currentToken = token

        do {
            try await client.connect(to: .server(serverURL))
        } catch {
            currentServerURL = previousServerURL
            currentToken = previousToken
            throw error
        }

        if serverURL == previousServerURL, tokenChanged, isConnected {
            try await authenticate()
        }
    }

    /// Updates the access token and retries authentication on an active connection.
    public func updateToken(_ token: String) async throws {
        currentToken = token
        guard isConnected else { return }
        try await authenticate()
    }

    /// Disconnects and resets authentication while preserving event subscriptions for later reuse.
    public func disconnect() async {
        currentToken = nil
        currentServerURL = nil
        isConnected = false
        authenticatedTransportConnectionID = nil
        await client.disconnect()
        setAuthState(.unauthenticated)
    }

    /// Permanently invalidates the session and finishes session-owned streams.
    public func invalidate() async {
        guard !isInvalidated else { return }
        isInvalidated = true
        currentToken = nil
        currentServerURL = nil
        isConnected = false
        authenticatedTransportConnectionID = nil
        setAuthState(.unauthenticated)

        statusObserverTask?.cancel()
        initObserverTask?.cancel()
        authFailedObserverTask?.cancel()
        statusObserverTask = nil
        initObserverTask = nil
        initObserverID = nil
        authFailedObserverTask = nil
        authFailedObserverID = nil

        for continuation in authStateContinuations.values {
            continuation.finish()
        }
        authStateContinuations.removeAll()
        await client.invalidate()
    }

    /// Returns a throwing typed stream using the event's declared delivery policy by default.
    public func events<Event: SocketEvent>(
        for event: Event.Type,
        policy: SocketStreamPolicy? = nil
    ) async -> SocketEventStream<Event> {
        await client.events(for: event, policy: policy)
    }

    /// Emits a client-originated event with a payload.
    public func emit<Event: EmittableSocketEvent>(
        _ event: Event.Type,
        _ payload: Event.Schema
    ) async throws {
        try await client.emit(event, payload)
    }

    /// Emits a zero-argument client-originated event.
    public func emit<Event: EmittableSocketEvent>(
        _ event: Event.Type
    ) async throws where Event.Schema == SocketEmptyBody {
        try await client.emit(event)
    }

    /// Returns transport status independently from Audiobookshelf authentication state.
    public func statusUpdates() async -> AsyncStream<SocketConnectionStatus> {
        await client.statusUpdates()
    }

    /// Returns the current authentication state and subsequent newest-state updates.
    public func authStateUpdates() -> AsyncStream<AuthState> {
        let subscriptionID = UUID()
        let (stream, continuation) = AsyncStream<AuthState>.makeStream(
            bufferingPolicy: .bufferingNewest(1)
        )
        continuation.yield(authState)

        guard !isInvalidated else {
            continuation.finish()
            return stream
        }

        authStateContinuations[subscriptionID] = continuation
        continuation.onTermination = { [weak self] _ in
            Task { await self?.removeAuthStateContinuation(subscriptionID) }
        }
        return stream
    }
}

// MARK: - Private Observation

extension ABSSocketSession {

    private func startObservationIfNeeded() async {
        guard !isInvalidated else { return }

        if statusObserverTask == nil {
            let statusStream = await client.statusUpdates()
            guard !isInvalidated, statusObserverTask == nil else { return }
            statusObserverTask = observeStatus(statusStream)
        }

        await startInitObservationIfNeeded()
        await startAuthFailedObservationIfNeeded()
    }

    private func startInitObservationIfNeeded() async {
        guard initObserverID == nil, !isInvalidated else { return }
        let observerID = UUID()
        initObserverID = observerID
        let stream = await client.events(for: InitEvent.self)
        guard initObserverID == observerID, !isInvalidated else { return }
        initObserverTask = observeInit(stream, observerID: observerID)
    }

    private func startAuthFailedObservationIfNeeded() async {
        guard authFailedObserverID == nil, !isInvalidated else { return }
        let observerID = UUID()
        authFailedObserverID = observerID
        let stream = await client.events(for: AuthFailedEvent.self)
        guard authFailedObserverID == observerID, !isInvalidated else { return }
        authFailedObserverTask = observeAuthFailure(stream, observerID: observerID)
    }

    private func observeStatus(
        _ stream: AsyncStream<SocketConnectionStatus>
    ) -> Task<Void, Never> {
        Task {
            for await status in stream {
                guard !Task.isCancelled else { return }
                await handleStatusChange(status)
            }
        }
    }

    private func observeInit(
        _ stream: SocketEventStream<InitEvent>,
        observerID: UUID
    ) -> Task<Void, Never> {
        Task {
            do {
                for try await payload in stream {
                    guard !Task.isCancelled else { return }
                    handleInit(payload)
                }
            } catch {
                guard !Task.isCancelled else { return }
                await initObservationTerminated(observerID, error: error)
                return
            }
            guard !Task.isCancelled else { return }
            await initObservationTerminated(observerID, error: nil)
        }
    }

    private func observeAuthFailure(
        _ stream: SocketEventStream<AuthFailedEvent>,
        observerID: UUID
    ) -> Task<Void, Never> {
        Task {
            do {
                for try await payload in stream {
                    guard !Task.isCancelled else { return }
                    handleAuthFailure(payload)
                }
            } catch {
                guard !Task.isCancelled else { return }
                await authFailedObservationTerminated(observerID, error: error)
                return
            }
            guard !Task.isCancelled else { return }
            await authFailedObservationTerminated(observerID, error: nil)
        }
    }

    private func initObservationTerminated(
        _ observerID: UUID,
        error: (any Error)?
    ) async {
        guard initObserverID == observerID else { return }
        initObserverTask = nil
        initObserverID = nil
        guard shouldReplaceAuthenticationObservation(after: error) else { return }
        if let error {
            setAuthState(.failed(message: error.localizedDescription))
        }
        await startInitObservationIfNeeded()
    }

    private func authFailedObservationTerminated(
        _ observerID: UUID,
        error: (any Error)?
    ) async {
        guard authFailedObserverID == observerID else { return }
        authFailedObserverTask = nil
        authFailedObserverID = nil
        guard shouldReplaceAuthenticationObservation(after: error) else { return }
        if let error {
            setAuthState(.failed(message: error.localizedDescription))
        }
        await startAuthFailedObservationIfNeeded()
    }

    private func shouldReplaceAuthenticationObservation(
        after error: (any Error)?
    ) -> Bool {
        guard !isInvalidated, let error else { return false }
        return error as? SocketIOError != .invalidated
    }

    private func handleStatusChange(_ status: SocketConnectionStatus) async {
        switch status {
        case .connected:
            await handleConnected()

        case .disconnected, .connecting, .reconnecting, .failed:
            isConnected = false
            authenticatedTransportConnectionID = nil
            setAuthState(.unauthenticated)

        case .invalidated:
            isConnected = false
            authenticatedTransportConnectionID = nil
            setAuthState(.unauthenticated)
        }
    }

    private func handleConnected() async {
        isConnected = true
        transportConnectionID &+= 1
        do {
            try await authenticate()
        } catch {
            setAuthState(.unauthenticated)
        }
    }

    private func authenticate() async throws {
        guard let currentToken else { return }
        setAuthState(.authenticating)
        do {
            try await client.emit(AuthEvent.self, currentToken)
        } catch {
            setAuthState(.unauthenticated)
            throw error
        }
    }

    private func handleInit(_ payload: InitEvent.Schema) {
        guard isConnected, authState == .authenticating else { return }

        if authenticatedTransportConnectionID != transportConnectionID {
            authenticatedConnectionID &+= 1
            authenticatedTransportConnectionID = transportConnectionID
        }

        setAuthState(
            .authenticated(
                connectionID: authenticatedConnectionID,
                userID: payload.userId,
                username: payload.username
            )
        )
    }

    private func handleAuthFailure(_ payload: AuthFailedEvent.Schema) {
        guard isConnected, authState == .authenticating else { return }
        setAuthState(.failed(message: payload.message))
    }

    private func setAuthState(_ state: AuthState) {
        guard authState != state else { return }
        authState = state
        for continuation in authStateContinuations.values {
            continuation.yield(state)
        }
    }

    private func removeAuthStateContinuation(_ subscriptionID: UUID) {
        authStateContinuations.removeValue(forKey: subscriptionID)
    }
}
