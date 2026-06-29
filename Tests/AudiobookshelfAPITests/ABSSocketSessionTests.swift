import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

private struct TestSocketEvent: SocketEvent {
    static let name = "test_event"

    struct Schema: Codable, Sendable, Equatable {
        let value: String
    }
}

private struct EmptyTestSocketEvent: SocketEvent {
    static let name = "empty_test_event"
    typealias Schema = SocketEmptyBody
}

private actor MockSocketClient: SocketClient {

    struct EmittedEvent: Sendable {
        let name: String
        let payload: Data?
    }

    enum MockError: Error {
        case emitFailed
    }

    private var status: SocketConnectionStatus = .disconnected
    private var statusContinuations: [UUID: AsyncStream<SocketConnectionStatus>.Continuation] = [:]
    private var eventContinuations: [String: [UUID: AsyncStream<Data>.Continuation]] = [:]
    private var pipeTasks: [UUID: Task<Void, Never>] = [:]

    private(set) var reconnectURLs: [URL] = []
    private(set) var emittedEvents: [EmittedEvent] = []
    private var emitError: MockError?

    func connect() async {}

    func disconnect() {}

    func reconnect(to newURL: URL) async {
        reconnectURLs.append(newURL)
    }

    func invalidate() {
        for continuations in eventContinuations.values {
            for continuation in continuations.values {
                continuation.finish()
            }
        }
        for continuation in statusContinuations.values {
            continuation.finish()
        }
        for task in pipeTasks.values {
            task.cancel()
        }
        eventContinuations = [:]
        statusContinuations = [:]
        pipeTasks = [:]
    }

    func emit<E: SocketEvent>(_ type: E.Type, _ payload: E.Schema) async throws
        where E.Schema: Encodable & Sendable {
        if let emitError {
            throw emitError
        }

        emittedEvents.append(
            EmittedEvent(
                name: E.name,
                payload: try JSONEncoder().encode(payload)
            )
        )
    }

    func emit<E: SocketEvent>(_ type: E.Type) async throws where E.Schema == SocketEmptyBody {
        if let emitError {
            throw emitError
        }

        emittedEvents.append(
            EmittedEvent(
                name: E.name,
                payload: nil
            )
        )
    }

    func events<E: SocketEvent>(for type: E.Type) -> AsyncStream<E.Schema> {
        let id = UUID()
        let (dataStream, dataContinuation) = AsyncStream<Data>.makeStream()
        eventContinuations[E.name, default: [:]][id] = dataContinuation

        dataContinuation.onTermination = { [weak self] _ in
            Task { [weak self] in await self?.removeEventContinuation(id, name: E.name) }
        }

        let (typedStream, typedContinuation) = AsyncStream<E.Schema>.makeStream()
        let pipeTask = Task {
            for await data in dataStream {
                guard let value = try? JSONDecoder().decode(E.Schema.self, from: data) else {
                    continue
                }
                typedContinuation.yield(value)
            }
            typedContinuation.finish()
        }

        pipeTasks[id] = pipeTask
        typedContinuation.onTermination = { _ in dataContinuation.finish() }
        return typedStream
    }

    func statusUpdates() -> AsyncStream<SocketConnectionStatus> {
        let id = UUID()
        let (stream, continuation) = AsyncStream<SocketConnectionStatus>.makeStream()
        statusContinuations[id] = continuation
        continuation.yield(status)
        continuation.onTermination = { [weak self] _ in
            Task { [weak self] in await self?.removeStatusContinuation(id) }
        }
        return stream
    }

    func pushStatus(_ newStatus: SocketConnectionStatus) {
        status = newStatus
        for continuation in statusContinuations.values {
            continuation.yield(newStatus)
        }
    }

    func pushEvent<Value: Encodable>(named name: String, payload: Value) throws {
        let data = try JSONEncoder().encode(payload)
        if let continuations = eventContinuations[name] {
            for continuation in continuations.values {
                continuation.yield(data)
            }
        }
    }

    func setEmitError(_ error: MockError?) {
        emitError = error
    }

    func emittedAuthTokens() throws -> [String] {
        try emittedEvents
            .filter { $0.name == AuthEvent.name }
            .compactMap { event in
                guard let payload = event.payload else { return nil }
                return try JSONDecoder().decode(String.self, from: payload)
            }
    }

    private func removeEventContinuation(_ id: UUID, name: String) {
        eventContinuations[name]?.removeValue(forKey: id)
        if eventContinuations[name]?.isEmpty == true {
            eventContinuations.removeValue(forKey: name)
        }
        pipeTasks[id]?.cancel()
        pipeTasks.removeValue(forKey: id)
    }

    private func removeStatusContinuation(_ id: UUID) {
        statusContinuations.removeValue(forKey: id)
    }
}

@Suite("ABSSocketSession Tests")
struct ABSSocketSessionTests {

    @Test("connect on a new URL reconnects transport and authenticates on connect")
    func connectAuthenticatesAfterTransportConnect() async throws {
        let client = MockSocketClient()
        let session = ABSSocketSession(client: client)
        await Task.yield()
        let authStates = await session.authStateUpdates()
        var authIterator = authStates.makeAsyncIterator()

        _ = await authIterator.next()

        let serverURL = try #require(URL(string: "https://example.com"))
        await session.connect(to: serverURL, token: "token-1")

        let expectedSocketURL = try #require(SocketIOURL.webSocketURL(for: serverURL))
        #expect(await client.reconnectURLs == [expectedSocketURL])

        await client.pushStatus(.connected)

        let authenticating = await authIterator.next()
        #expect(authenticating == .authenticating)
        #expect(try await client.emittedAuthTokens() == ["token-1"])
    }

    @Test("connect on the same URL updates token without reconnecting")
    func sameURLConnectRefreshesToken() async throws {
        let client = MockSocketClient()
        let session = ABSSocketSession(client: client)
        await Task.yield()

        let serverURL = try #require(URL(string: "http://example.com"))
        await session.connect(to: serverURL, token: "token-1")
        await client.pushStatus(.connected)
        await Task.yield()

        await session.connect(to: serverURL, token: "token-2")

        let expectedSocketURL = try #require(SocketIOURL.webSocketURL(for: serverURL))
        #expect(await client.reconnectURLs == [expectedSocketURL])
        #expect(try await client.emittedAuthTokens() == ["token-1", "token-2"])
    }

    @Test("auth success and failure events update auth state")
    func authEventsUpdateAuthState() async throws {
        let client = MockSocketClient()
        let session = ABSSocketSession(client: client)
        await Task.yield()
        let authStates = await session.authStateUpdates()
        var authIterator = authStates.makeAsyncIterator()

        _ = await authIterator.next()

        await session.connect(to: try #require(URL(string: "http://example.com")), token: "token-1")
        await client.pushStatus(.connected)
        _ = await authIterator.next()

        try await client.pushEvent(
            named: "init",
            payload: ["userId": "user-1", "username": "alice"]
        )

        let authenticated = await authIterator.next()
        #expect(authenticated == .authenticated(userID: "user-1", username: "alice"))

        try await client.pushEvent(
            named: "auth_failed",
            payload: ["message": "bad token"]
        )

        let failed = await authIterator.next()
        #expect(failed == .failed(message: "bad token"))
    }

    @Test("emit failures surface as failed auth state")
    func emitFailureUpdatesAuthState() async throws {
        let client = MockSocketClient()
        let session = ABSSocketSession(client: client)
        await Task.yield()
        let authStates = await session.authStateUpdates()
        var authIterator = authStates.makeAsyncIterator()

        _ = await authIterator.next()

        await session.connect(to: try #require(URL(string: "http://example.com")), token: "token-1")
        await client.pushStatus(.connected)
        _ = await authIterator.next()

        await client.setEmitError(.emitFailed)
        await session.updateToken("token-2")

        let failed = await authIterator.next()
        #expect(failed == .failed(message: MockSocketClient.MockError.emitFailed.localizedDescription))
    }

    @Test("typed event streams survive reconnects")
    func typedEventStreamsSurviveReconnects() async throws {
        let client = MockSocketClient()
        let session = ABSSocketSession(client: client)
        await Task.yield()
        let stream = await session.events(for: TestSocketEvent.self)
        var iterator = stream.makeAsyncIterator()

        let serverURL = try #require(URL(string: "http://example.com"))
        await session.connect(to: serverURL, token: "token-1")
        await client.pushStatus(.connected)
        await session.disconnect()
        await session.connect(to: serverURL, token: "token-2")
        await client.pushStatus(.connected)

        try await client.pushEvent(
            named: TestSocketEvent.name,
            payload: TestSocketEvent.Schema(value: "after-reconnect")
        )

        let event = await iterator.next()
        #expect(event == .init(value: "after-reconnect"))
    }

    @Test("emit with payload passes through to transport")
    func emitWithPayloadPassesThrough() async throws {
        let client = MockSocketClient()
        let session = ABSSocketSession(client: client)

        try await session.emit(TestSocketEvent.self, .init(value: "payload"))

        let events = await client.emittedEvents
        #expect(events.count == 1)
        #expect(events.first?.name == TestSocketEvent.name)

        let data = try #require(events.first?.payload)
        let payload = try JSONDecoder().decode(TestSocketEvent.Schema.self, from: data)
        #expect(payload == .init(value: "payload"))
    }

    @Test("emit without payload passes through to transport")
    func emitWithoutPayloadPassesThrough() async throws {
        let client = MockSocketClient()
        let session = ABSSocketSession(client: client)

        try await session.emit(EmptyTestSocketEvent.self)

        let events = await client.emittedEvents
        #expect(events.count == 1)
        #expect(events.first?.name == EmptyTestSocketEvent.name)
        #expect(events.first?.payload == nil)
    }

    @Test("status updates stream delegates current and subsequent transport status")
    func statusUpdatesDelegateTransportStatus() async {
        let client = MockSocketClient()
        let session = ABSSocketSession(client: client)
        let stream = await session.statusUpdates()
        var iterator = stream.makeAsyncIterator()

        let initial = await iterator.next()
        #expect(initial == .disconnected)

        await client.pushStatus(.connecting)
        let connecting = await iterator.next()
        #expect(connecting == .connecting)
    }
}
