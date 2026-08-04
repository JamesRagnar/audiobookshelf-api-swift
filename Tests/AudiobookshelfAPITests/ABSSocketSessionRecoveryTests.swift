import AudiobookshelfAPI
import Foundation
import RagnarSocketIO
import Testing

@Suite("ABSSocketSession Recovery Tests")
struct ABSSocketSessionRecoveryTests {

    @Test("malformed init subscription is replaced before reconnect authentication")
    func malformedInitRecoversAcrossReconnect() async throws {
        let client = TestSocketClient()
        let session = ABSSocketSession(client: client)
        let serverURL = try #require(URL(string: "https://example.com"))
        try await session.connect(to: serverURL, token: "token-1")
        await client.pushStatus(.connected)
        try await waitForAuthTokens(["token-1"], from: client)
        #expect(await client.eventSubscriptionPolicies[InitEvent.name] == [.lossless])
        #expect(await client.eventSubscriptionPolicies["auth_failed"] == [.lossless])

        try await client.pushEvent(
            named: InitEvent.name,
            payload: "malformed"
        )
        try await waitForSubscriptionCreations(
            2,
            eventName: InitEvent.name,
            client: client
        )
        try await waitForSubscriptionCount(
            1,
            eventName: InitEvent.name,
            client: client
        )
        #expect(await client.eventSubscriptionCreations["auth_failed"] == 1)
        #expect(await client.eventSubscriptionCount(named: "auth_failed") == 1)

        await session.disconnect()
        try await session.connect(to: serverURL, token: "token-2")
        await client.pushStatus(.connected)
        try await waitForAuthTokens(["token-1", "token-2"], from: client)
        try await client.pushEvent(
            named: InitEvent.name,
            payload: InitPayload(userId: "user-1", username: "alice")
        )

        try await waitForAuthState(
            .authenticated(connectionID: 1, userID: "user-1", username: "alice"),
            from: session
        )
        #expect(await client.eventSubscriptionCreations[InitEvent.name] == 2)
        #expect(await client.eventSubscriptionCreations["auth_failed"] == 1)
        #expect(await client.eventSubscriptionCount(named: InitEvent.name) == 1)
        #expect(await client.eventSubscriptionCount(named: "auth_failed") == 1)
    }

    @Test("auth failure subscription is replaced after overflow")
    func authFailureObserverRecoversAfterOverflow() async throws {
        let client = TestSocketClient()
        let session = ABSSocketSession(client: client)
        try await session.connect(
            to: #require(URL(string: "https://example.com")),
            token: "token"
        )
        await client.pushStatus(.connected)
        try await waitForAuthTokens(["token"], from: client)

        #expect(try await !client.pushEvent(
            named: "auth_failed",
            payload: AuthFailurePayload(message: "overflow"),
            repetitions: 1_000
        ))
        try await waitForSubscriptionCreations(
            2,
            eventName: "auth_failed",
            client: client
        )
        try await waitForSubscriptionCount(
            1,
            eventName: "auth_failed",
            client: client
        )
        #expect(await client.eventSubscriptionCreations[InitEvent.name] == 1)
        #expect(await client.eventSubscriptionCount(named: InitEvent.name) == 1)

        await client.pushStatus(.reconnecting(attempt: 1))
        await client.pushStatus(.connected)
        try await waitForAuthTokens(["token", "token"], from: client)
        try await client.pushEvent(
            named: "auth_failed",
            payload: AuthFailurePayload(message: "invalid token")
        )
        try await waitForAuthState(
            .failed(message: "invalid token"),
            from: session
        )
        #expect(await client.eventSubscriptionCreations[InitEvent.name] == 1)
        #expect(await client.eventSubscriptionCreations["auth_failed"] == 2)
        #expect(await client.eventSubscriptionCount(named: InitEvent.name) == 1)
        #expect(await client.eventSubscriptionCount(named: "auth_failed") == 1)
    }

    @Test("normally completed subscription is restored by the next connect")
    func normalCompletionWaitsForConnectBeforeReplacement() async throws {
        let client = TestSocketClient()
        let session = ABSSocketSession(client: client)
        let serverURL = try #require(URL(string: "https://example.com"))
        try await session.connect(to: serverURL, token: "token")

        await client.finishEventStreams(named: InitEvent.name)
        try await waitForSubscriptionCount(
            0,
            eventName: InitEvent.name,
            client: client
        )
        try await Task.sleep(for: .milliseconds(10))
        #expect(await client.eventSubscriptionCreations[InitEvent.name] == 1)

        try await session.connect(to: serverURL, token: "token")
        try await waitForSubscriptionCreations(
            2,
            eventName: InitEvent.name,
            client: client
        )
        try await waitForSubscriptionCount(
            1,
            eventName: InitEvent.name,
            client: client
        )
    }

    @Test("invalidation never restarts authentication observers")
    func invalidationDoesNotRestartObservers() async throws {
        let client = TestSocketClient()
        let session = ABSSocketSession(client: client)
        try await session.connect(
            to: #require(URL(string: "https://example.com")),
            token: "token"
        )

        await session.invalidate()
        try await Task.sleep(for: .milliseconds(10))

        #expect(await client.eventSubscriptionCreations[InitEvent.name] == 1)
        #expect(await client.eventSubscriptionCreations["auth_failed"] == 1)
        #expect(await client.eventSubscriptionCount(named: InitEvent.name) == 0)
        #expect(await client.eventSubscriptionCount(named: "auth_failed") == 0)
    }

    private func currentAuthState(
        of session: ABSSocketSession
    ) async -> ABSSocketSession.AuthState? {
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
            try await Task.sleep(for: .milliseconds(1))
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
            try await Task.sleep(for: .milliseconds(1))
        }
        Issue.record("Auth tokens did not become \(expected)")
    }

    private func waitForSubscriptionCreations(
        _ expected: Int,
        eventName: String,
        client: TestSocketClient
    ) async throws {
        for _ in 0..<100 {
            if await client.eventSubscriptionCreations[eventName] == expected {
                return
            }
            try await Task.sleep(for: .milliseconds(1))
        }
        Issue.record("Subscription creations did not become \(expected)")
    }

    private func waitForSubscriptionCount(
        _ expected: Int,
        eventName: String,
        client: TestSocketClient
    ) async throws {
        for _ in 0..<100 {
            if await client.eventSubscriptionCount(named: eventName) == expected {
                return
            }
            try await Task.sleep(for: .milliseconds(1))
        }
        Issue.record("Subscription count did not become \(expected)")
    }
}
