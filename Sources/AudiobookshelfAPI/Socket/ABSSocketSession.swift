//
//  ABSSocketSession.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2025-06-22.
//

import Foundation
import RagnarNetworking

/// Wraps SocketIOClient with the ABS-specific auth handshake.
///
/// Auth protocol: on every SocketIOClient `.connected` transition, emits `AuthEvent` with the
/// current JWT. Server responds with the private `InitEvent` (success) or `AuthFailedEvent`.
///
/// All event streams and status streams are delegated to the underlying `SocketIOClient`,
/// which keeps them alive across disconnect/reconnect cycles without re-subscription.
public actor ABSSocketSession {

    // MARK: - Public Types

    public enum AuthState: Sendable, Equatable {
        case unauthenticated
        case authenticating
        case authenticated(userID: String, username: String)
        case failed(message: String)
    }

    // MARK: - Private ABS Server Events

    // These event shapes are internal to the auth handshake — no public surface.

    private struct InitEvent: SocketEvent {
        static let name = "init"
        struct Schema: Decodable, Sendable {
            let userId: String
            let username: String
        }
    }

    private struct AuthFailedEvent: SocketEvent {
        static let name = "auth_failed"
        struct Schema: Decodable, Sendable {
            let message: String
        }
    }

    // MARK: - Private State

    private let client: SocketIOClient
    private var currentToken: String?
    private var currentServerURL: URL?
    private var isConnected = false
    private var authState: AuthState = .unauthenticated

    private var statusObserverTask: Task<Void, Never>?
    private var initObserverTask: Task<Void, Never>?
    private var authFailedObserverTask: Task<Void, Never>?
    private var authStateContinuations: [UUID: AsyncStream<AuthState>.Continuation] = [:]

    // MARK: - Init

    /// Create a session backed by the given client. The client need not be connected yet;
    /// call `connect(to:token:)` when ready.
    public init(client: SocketIOClient) {
        self.client = client
        // Actor init is nonisolated in Swift 6 — schedule observation on the actor executor.
        Task { await self.startObservation() }
    }

    // MARK: - Public API

    /// Connect (or reconnect) to the given server URL with the provided JWT.
    /// - Same URL: re-emits auth with the new token if connected; no reconnect.
    /// - New URL: switches the underlying WebSocket connection, preserving existing event streams.
    public func connect(to serverURL: URL, token: String) async {
        if serverURL == currentServerURL {
            await updateToken(token)
        } else {
            guard let wsURL = SocketIOClient.webSocketURL(for: serverURL) else {
                return
            }
            currentServerURL = serverURL
            currentToken = token
            await client.reconnect(to: wsURL)
        }
    }

    /// Update the auth token without reconnecting. Re-emits `AuthEvent` if currently connected.
    public func updateToken(_ token: String) async {
        currentToken = token
        guard isConnected else { return }
        do {
            try await client.emit(AuthEvent.self, token)
            setAuthState(.authenticating)
        } catch {
            setAuthState(.failed(message: error.localizedDescription))
        }
    }

    /// Close the connection and reset auth state. Existing event streams are preserved for reconnect.
    public func disconnect() async {
        currentToken = nil
        currentServerURL = nil
        isConnected = false
        await client.disconnect()
        setAuthState(.unauthenticated)
    }

    /// Returns a typed `AsyncStream` for the given event type. Delegates directly to the
    /// underlying `SocketIOClient`, so the stream survives reconnects without re-subscription.
    public func events<E: SocketEvent>(for type: E.Type) async -> AsyncStream<E.Schema> {
        await client.events(for: type)
    }

    /// Emit a typed client event.
    public func emit<E: SocketEvent>(_ type: E.Type, _ payload: E.Schema) async throws
        where E.Schema: Encodable & Sendable {
        try await client.emit(type, payload)
    }

    /// Emit a typed client event with no payload.
    public func emit<E: SocketEvent>(_ type: E.Type) async throws
        where E.Schema == SocketEmptyBody {
        try await client.emit(type)
    }

    /// Stream of auth state changes. Emits the current state immediately on subscribe.
    public func authStateUpdates() -> AsyncStream<AuthState> {
        let id = UUID()
        let (stream, continuation) = AsyncStream<AuthState>.makeStream()
        authStateContinuations[id] = continuation
        continuation.yield(authState)
        continuation.onTermination = { [weak self] _ in
            Task { [weak self] in await self?.removeAuthStateContinuation(id) }
        }
        return stream
    }

    /// Stream of connection status changes. Delegates to the underlying SocketIOClient.
    public func statusUpdates() async -> AsyncStream<SocketIOClient.Status> {
        await client.statusUpdates()
    }

    // MARK: - Private: Observation

    // Started once in init. These tasks run for the lifetime of the session actor.
    // SocketIOClient continuations persist across reconnects, so these tasks naturally
    // resume receiving events after a disconnect/reconnect cycle.
    private func startObservation() {
        statusObserverTask = Task {
            let stream = await client.statusUpdates()
            for await status in stream {
                guard !Task.isCancelled else { return }
                await self.handleStatusChange(status)
            }
        }

        initObserverTask = Task {
            let stream = await client.events(for: InitEvent.self)
            for await body in stream {
                guard !Task.isCancelled else { return }
                self.setAuthState(.authenticated(userID: body.userId, username: body.username))
            }
        }

        authFailedObserverTask = Task {
            let stream = await client.events(for: AuthFailedEvent.self)
            for await body in stream {
                guard !Task.isCancelled else { return }
                self.setAuthState(.failed(message: body.message))
            }
        }
    }

    private func handleStatusChange(_ status: SocketIOClient.Status) async {
        isConnected = (status == .connected)
        if status == .connected, let token = currentToken {
            do {
                try await client.emit(AuthEvent.self, token)
                setAuthState(.authenticating)
            } catch {
                setAuthState(.failed(message: error.localizedDescription))
            }
        }
    }

    private func setAuthState(_ state: AuthState) {
        authState = state
        for cont in authStateContinuations.values { cont.yield(state) }
    }

    private func removeAuthStateContinuation(_ id: UUID) {
        authStateContinuations.removeValue(forKey: id)
    }
}
