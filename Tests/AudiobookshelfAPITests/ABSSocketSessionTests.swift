import AudiobookshelfAPI
import Foundation
import RagnarSocketIO
import Testing

private struct TestSocketEvent: SocketEvent {
    static let name = "test_event"

    struct Schema: Codable, Sendable, Equatable {
        let value: String
    }
}

private struct TestClientEvent: EmittableSocketEvent {
    static let name = "test_client_event"

    struct Schema: Codable, Sendable, Equatable {
        let value: String
    }
}

private struct EmptyTestClientEvent: EmittableSocketEvent {
    static let name = "empty_test_client_event"
    typealias Schema = SocketEmptyBody
}

private struct InitPayload: Encodable {
    let userId: String
    let username: String
}

private struct AuthFailurePayload: Encodable {
    let message: String
}

private actor TestSocketClient: SocketClient {

    struct EmittedEvent: Sendable {
        let name: String
        let arguments: [SocketIOArgument]
    }

    enum TestError: Error, Sendable, Equatable {
        case connectFailed
        case emitFailed
    }

    private struct EventSource: Sendable {
        let yield: @Sendable ([SocketIOArgument]) -> Bool
        let finish: @Sendable ((any Error)?) -> Void
    }

    private var status: SocketConnectionStatus = .disconnected
    private var statusContinuations: [UUID: AsyncStream<SocketConnectionStatus>.Continuation] = [:]
    private var eventSources: [String: [UUID: EventSource]] = [:]
    private var connectError: (any Error)?
    private var emitError: (any Error)?
    private var activeEndpoint: SocketIOEndpoint?

    private(set) var requestedEndpoints: [SocketIOEndpoint] = []
    private(set) var connectionGenerations = 0
    private(set) var emittedEvents: [EmittedEvent] = []
    private(set) var observersInstalledAtFirstConnect = false
    private(set) var disconnectCount = 0
    private(set) var invalidateCount = 0

    func connect(to endpoint: SocketIOEndpoint) throws {
        observersInstalledAtFirstConnect = observersInstalledAtFirstConnect || (
            !statusContinuations.isEmpty
                && eventSources[InitEvent.name]?.isEmpty == false
                && eventSources["auth_failed"]?.isEmpty == false
        )
        if let connectError {
            throw connectError
        }

        requestedEndpoints.append(endpoint)
        guard endpoint != activeEndpoint || !status.isActive else { return }
        activeEndpoint = endpoint
        connectionGenerations += 1
        pushStatus(.connecting)
    }

    func disconnect() {
        disconnectCount += 1
        activeEndpoint = nil
        pushStatus(.disconnected)
    }

    func invalidate() {
        invalidateCount += 1
        status = .invalidated
        for sources in eventSources.values {
            for source in sources.values {
                source.finish(SocketIOError.invalidated)
            }
        }
        eventSources.removeAll()
        for continuation in statusContinuations.values {
            continuation.yield(.invalidated)
            continuation.finish()
        }
        statusContinuations.removeAll()
    }

    func emit<Event: EmittableSocketEvent>(
        _ event: Event.Type,
        _ payload: Event.Schema
    ) async throws {
        if let emitError {
            throw emitError
        }
        emittedEvents.append(
            EmittedEvent(
                name: Event.name,
                arguments: try Event.encode(payload, using: JSONEncoder())
            )
        )
    }

    func emit<Event: EmittableSocketEvent>(
        _ event: Event.Type
    ) async throws where Event.Schema == SocketEmptyBody {
        try await emit(event, SocketEmptyBody())
    }

    func events<Event: SocketEvent>(
        for event: Event.Type,
        policy: SocketStreamPolicy?
    ) -> SocketEventStream<Event> {
        let subscriptionID = UUID()
        let source = SocketEventStream<Event>.makeStream(
            policy: policy ?? Event.defaultStreamPolicy,
            onTermination: { [weak self] in
                Task {
                    await self?.removeEventSource(
                        subscriptionID,
                        eventName: Event.name
                    )
                }
            }
        )
        eventSources[Event.name, default: [:]][subscriptionID] = EventSource(
            yield: { source.yield(arguments: $0) },
            finish: { error in
                if let error {
                    source.finish(throwing: error)
                } else {
                    source.finish()
                }
            }
        )
        return source.stream
    }

    func statusUpdates() -> AsyncStream<SocketConnectionStatus> {
        let subscriptionID = UUID()
        let (stream, continuation) = AsyncStream<SocketConnectionStatus>.makeStream(
            bufferingPolicy: .bufferingNewest(1)
        )
        continuation.yield(status)
        statusContinuations[subscriptionID] = continuation
        continuation.onTermination = { [weak self] _ in
            Task { await self?.removeStatusContinuation(subscriptionID) }
        }
        return stream
    }

    func pushStatus(_ newStatus: SocketConnectionStatus) {
        status = newStatus
        for continuation in statusContinuations.values {
            continuation.yield(newStatus)
        }
    }

    @discardableResult
    func pushEvent<Value: Encodable & Sendable>(
        named name: String,
        payload: Value
    ) throws -> Bool {
        try pushArguments(
            named: name,
            arguments: [SocketIOArgument(payload)]
        )
    }

    @discardableResult
    func pushArguments(
        named name: String,
        arguments: [SocketIOArgument]
    ) -> Bool {
        eventSources[name]?.values.reduce(true) { result, source in
            source.yield(arguments) && result
        } ?? true
    }

    func setConnectError(_ error: (any Error)?) {
        connectError = error
    }

    func setEmitError(_ error: (any Error)?) {
        emitError = error
    }

    func emittedAuthTokens() throws -> [String] {
        try emittedEvents
            .filter { $0.name == AuthEvent.name }
            .map { event in
                try #require(event.arguments.first).decode(String.self)
            }
    }

    private func removeEventSource(_ subscriptionID: UUID, eventName: String) {
        eventSources[eventName]?.removeValue(forKey: subscriptionID)
        if eventSources[eventName]?.isEmpty == true {
            eventSources.removeValue(forKey: eventName)
        }
    }

    private func removeStatusContinuation(_ subscriptionID: UUID) {
        statusContinuations.removeValue(forKey: subscriptionID)
    }
}

private extension SocketConnectionStatus {
    var isActive: Bool {
        switch self {
        case .connecting, .connected, .reconnecting:
            true
        case .disconnected, .failed, .invalidated:
            false
        }
    }
}

@Suite("ABSSocketSession Tests")
struct ABSSocketSessionTests {

    @Test("observers are installed before the first connection")
    func observersPrecedeConnection() async throws {
        let client = TestSocketClient()
        let session = ABSSocketSession(client: client)

        try await session.connect(
            to: #require(URL(string: "https://example.com")),
            token: "token"
        )

        #expect(await client.observersInstalledAtFirstConnect)
    }

    @Test("root and RouterBasePath URLs pass through server endpoints")
    func serverURLsPassThrough() async throws {
        let client = TestSocketClient()
        let session = ABSSocketSession(client: client)
        let rootURL = try #require(URL(string: "https://example.com"))
        let routedURL = try #require(URL(string: "http://example.com/audiobookshelf"))

        try await session.connect(to: rootURL, token: "first")
        try await session.connect(to: routedURL, token: "second")

        #expect(await client.requestedEndpoints == [.server(rootURL), .server(routedURL)])
        #expect(await client.connectionGenerations == 2)
    }

    @Test("auth emits only after connected and init gates success")
    func connectionAndInitGateAuthentication() async throws {
        let client = TestSocketClient()
        let session = ABSSocketSession(client: client)
        try await session.connect(
            to: #require(URL(string: "https://example.com")),
            token: "token-1"
        )

        #expect(try await client.emittedAuthTokens().isEmpty)

        await client.pushStatus(.connected)
        try await waitForAuthTokens(["token-1"], from: client)
        #expect(await currentAuthState(of: session) == .authenticating)

        try await client.pushEvent(
            named: InitEvent.name,
            payload: InitPayload(userId: "user-1", username: "alice")
        )

        try await waitForAuthState(
            .authenticated(
                connectionID: 1,
                userID: "user-1",
                username: "alice"
            ),
            from: session
        )
    }

    @Test("auth failure keeps transport available for token retry")
    func authFailureAllowsTokenRetry() async throws {
        let client = TestSocketClient()
        let session = ABSSocketSession(client: client)
        try await session.connect(
            to: #require(URL(string: "https://example.com")),
            token: "bad-token"
        )
        await client.pushStatus(.connected)
        try await waitForAuthTokens(["bad-token"], from: client)

        try await client.pushEvent(
            named: "auth_failed",
            payload: AuthFailurePayload(message: "invalid token")
        )
        try await waitForAuthState(
            .failed(message: "invalid token"),
            from: session
        )

        try await session.updateToken("good-token")

        #expect(try await client.emittedAuthTokens() == ["bad-token", "good-token"])
        #expect(await currentAuthState(of: session) == .authenticating)
        #expect(await client.connectionGenerations == 1)
    }

    @Test("same URL token change retries without a new transport generation")
    func sameURLTokenChangeRetriesAuthentication() async throws {
        let client = TestSocketClient()
        let session = ABSSocketSession(client: client)
        let serverURL = try #require(URL(string: "https://example.com"))
        try await session.connect(to: serverURL, token: "token-1")
        await client.pushStatus(.connected)
        try await waitForAuthTokens(["token-1"], from: client)

        try await session.connect(to: serverURL, token: "token-2")

        #expect(try await client.emittedAuthTokens() == ["token-1", "token-2"])
        #expect(await client.connectionGenerations == 1)
    }

    @Test("reconnect authenticates again with a new connection identity")
    func reconnectChangesAuthenticatedConnectionIdentity() async throws {
        let client = TestSocketClient()
        let session = ABSSocketSession(client: client)
        try await session.connect(
            to: #require(URL(string: "https://example.com")),
            token: "token-1"
        )
        await client.pushStatus(.connected)
        try await waitForAuthTokens(["token-1"], from: client)
        try await client.pushEvent(
            named: InitEvent.name,
            payload: InitPayload(userId: "user-1", username: "alice")
        )
        try await waitForAuthState(
            .authenticated(connectionID: 1, userID: "user-1", username: "alice"),
            from: session
        )

        await client.pushStatus(.reconnecting(attempt: 1))
        await client.pushStatus(.connected)
        try await waitForAuthTokens(["token-1", "token-1"], from: client)
        try await client.pushEvent(
            named: InitEvent.name,
            payload: InitPayload(userId: "user-1", username: "alice")
        )

        try await waitForAuthState(
            .authenticated(connectionID: 2, userID: "user-1", username: "alice"),
            from: session
        )
    }

    @Test("switching servers starts a new connection generation")
    func switchingServersStartsNewGeneration() async throws {
        let client = TestSocketClient()
        let session = ABSSocketSession(client: client)
        try await session.connect(
            to: #require(URL(string: "https://one.example.com")),
            token: "first"
        )
        try await session.connect(
            to: #require(URL(string: "https://two.example.com/base")),
            token: "second"
        )

        #expect(await client.connectionGenerations == 2)
    }

    @Test("disconnect preserves typed event subscriptions")
    func disconnectPreservesEventSubscriptions() async throws {
        let client = TestSocketClient()
        let session = ABSSocketSession(client: client)
        let stream = await session.events(for: TestSocketEvent.self)
        var iterator = stream.makeAsyncIterator()
        let serverURL = try #require(URL(string: "https://example.com"))

        try await session.connect(to: serverURL, token: "first")
        await session.disconnect()
        try await session.connect(to: serverURL, token: "second")
        try await client.pushEvent(
            named: TestSocketEvent.name,
            payload: TestSocketEvent.Schema(value: "after reconnect")
        )

        #expect(try await iterator.next() == .init(value: "after reconnect"))
        #expect(await client.disconnectCount == 1)
        #expect(await currentAuthState(of: session) == .unauthenticated)
    }

    @Test("session emit methods preserve transport errors")
    func emitErrorsRemainThrown() async throws {
        let client = TestSocketClient()
        let session = ABSSocketSession(client: client)
        await client.setEmitError(TestSocketClient.TestError.emitFailed)

        await #expect(throws: TestSocketClient.TestError.emitFailed) {
            try await session.emit(
                TestClientEvent.self,
                .init(value: "payload")
            )
        }
        await #expect(throws: TestSocketClient.TestError.emitFailed) {
            try await session.emit(EmptyTestClientEvent.self)
        }
    }

    @Test("token auth emit failures remain thrown")
    func tokenAuthEmitErrorsRemainThrown() async throws {
        let client = TestSocketClient()
        let session = ABSSocketSession(client: client)
        try await session.connect(
            to: #require(URL(string: "https://example.com")),
            token: "token-1"
        )
        await client.pushStatus(.connected)
        try await waitForAuthTokens(["token-1"], from: client)
        await client.setEmitError(TestSocketClient.TestError.emitFailed)

        await #expect(throws: TestSocketClient.TestError.emitFailed) {
            try await session.updateToken("token-2")
        }
        #expect(await currentAuthState(of: session) == .unauthenticated)
    }

    @Test("endpoint validation errors remain thrown")
    func endpointErrorsRemainThrown() async throws {
        let client = TestSocketClient()
        let session = ABSSocketSession(client: client)
        await client.setConnectError(SocketIOProtocolError.invalidEndpoint)

        await #expect(throws: SocketIOProtocolError.invalidEndpoint) {
            try await session.connect(
                to: #require(URL(string: "file:///tmp/server")),
                token: "token"
            )
        }
        #expect(await currentAuthState(of: session) == .unauthenticated)
    }

    @Test("lossless stream overflow remains observable")
    func losslessOverflowRemainsObservable() async throws {
        let client = TestSocketClient()
        let session = ABSSocketSession(client: client)
        let stream = await session.events(
            for: TestSocketEvent.self,
            policy: try .lossless(capacity: 1)
        )
        var iterator = stream.makeAsyncIterator()

        #expect(try await client.pushEvent(
            named: TestSocketEvent.name,
            payload: TestSocketEvent.Schema(value: "first")
        ))
        #expect(try await !client.pushEvent(
            named: TestSocketEvent.name,
            payload: TestSocketEvent.Schema(value: "second")
        ))
        #expect(try await iterator.next() == .init(value: "first"))
        await #expect(throws: SocketIOError.bufferOverflow(eventName: TestSocketEvent.name)) {
            try await iterator.next()
        }
    }

    @Test("invalidate finishes session and event streams")
    func invalidateFinishesStreams() async throws {
        let client = TestSocketClient()
        let session = ABSSocketSession(client: client)
        let authStates = await session.authStateUpdates()
        var authIterator = authStates.makeAsyncIterator()
        let events = await session.events(for: TestSocketEvent.self)
        var eventIterator = events.makeAsyncIterator()
        _ = await authIterator.next()

        await session.invalidate()

        #expect(await authIterator.next() == nil)
        await #expect(throws: SocketIOError.invalidated) {
            try await eventIterator.next()
        }
        #expect(await client.invalidateCount == 1)
    }

    @Test("status updates expose transport state separately")
    func statusUpdatesExposeTransportState() async {
        let client = TestSocketClient()
        let session = ABSSocketSession(client: client)
        let statuses = await session.statusUpdates()
        var iterator = statuses.makeAsyncIterator()

        #expect(await iterator.next() == .disconnected)
        await client.pushStatus(.reconnecting(attempt: 2))
        #expect(await iterator.next() == .reconnecting(attempt: 2))
        #expect(await currentAuthState(of: session) == .unauthenticated)
    }

    private func currentAuthState(of session: ABSSocketSession) async -> ABSSocketSession.AuthState? {
        var iterator = await session.authStateUpdates().makeAsyncIterator()
        return await iterator.next()
    }

    private func waitForAuthState(
        _ expected: ABSSocketSession.AuthState,
        from session: ABSSocketSession
    ) async throws {
        for _ in 0..<100 {
            if await currentAuthState(of: session) == expected {
                return
            }
            await Task.yield()
        }
        Issue.record("Auth state did not become \(expected)")
    }

    private func waitForAuthTokens(
        _ expected: [String],
        from client: TestSocketClient
    ) async throws {
        for _ in 0..<100 {
            if try await client.emittedAuthTokens() == expected {
                return
            }
            await Task.yield()
        }
        Issue.record("Auth tokens did not become \(expected)")
    }
}
