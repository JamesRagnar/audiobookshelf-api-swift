import AudiobookshelfAPI
import Foundation
import RagnarSocketIO
import Testing

struct TestSocketEvent: SocketEvent {
    static let name = "test_event"

    struct Schema: Codable, Sendable, Equatable {
        let value: String
    }
}

struct TestClientEvent: EmittableSocketEvent {
    static let name = "test_client_event"

    struct Schema: Codable, Sendable, Equatable {
        let value: String
    }
}

struct EmptyTestClientEvent: EmittableSocketEvent {
    static let name = "empty_test_client_event"
    typealias Schema = SocketEmptyBody
}

struct InitPayload: Encodable {
    let userId: String
    let username: String
}

struct AuthFailurePayload: Encodable {
    let message: String
}

actor TestSocketClient: SocketClient {

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
        eventSources[name]?.values
            .map { $0.yield(arguments) }
            .allSatisfy { $0 } ?? true
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
