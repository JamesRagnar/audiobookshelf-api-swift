# Sockets

`AudiobookshelfAPI` provides typed Audiobookshelf event contracts and `ABSSocketSession` for authenticated realtime
updates. `RagnarSocketIO` provides the Socket.IO client, WebSocket transport, heartbeat, and automatic reconnect behavior.

## Create a Session

```swift
import AudiobookshelfAPI
import RagnarSocketIO

let socketClient = SocketIOClient()
let socketSession = ABSSocketSession(client: socketClient)

try await socketSession.connect(
    to: serverURL,
    token: accessToken
)
```

Pass the configured HTTP or HTTPS Audiobookshelf server URL to `connect(to:token:)`. The URL may include a
RouterBasePath, such as `https://example.com/audiobookshelf`. `RagnarSocketIO` resolves the WebSocket scheme,
Socket.IO path, and Engine.IO query items. Do not construct a WebSocket URL or add the access token to the upgrade
request.

Socket authentication requires an access token. API keys and refresh tokens are not supported by this socket contract.
The session emits the access token after every initial Socket.IO connection and automatic reconnect.

Use `updateToken(_:)` when the access token changes. If the transport is connected, the session retries authentication
without replacing it.

```swift
try await socketSession.updateToken(newAccessToken)
```

## Transport and Authentication State

Transport state and Audiobookshelf authentication state are separate.

```swift
for await status in await socketSession.statusUpdates() {
    switch status {
    case .connected:
        print("Socket.IO connected")
    case .reconnecting(let attempt):
        print("Reconnect attempt \(attempt)")
    default:
        break
    }
}
```

A connected transport is not ready for Audiobookshelf events until the server responds to authentication with `init`.

```swift
var lastConnectionID: UInt64?

for await state in await socketSession.authStateUpdates() {
    switch state {
    case .authenticated(let connectionID, let userID, let username):
        if connectionID != lastConnectionID {
            lastConnectionID = connectionID
            await reloadRelevantRESTSnapshots()
            print("Authenticated as \(userID) / \(username)")
        }

    case .failed(let message):
        print("Socket authentication failed: \(message)")

    case .unauthenticated, .authenticating:
        break
    }
}
```

`authStateUpdates()` is a current-state stream. It emits the current value immediately and buffers only the newest
state. It is not a lossless event log. Each successfully authenticated Socket.IO connection receives a new monotonically
changing `connectionID`, including the initial connection and every successful reconnect.

Run the relevant REST snapshot load after every new authenticated `connectionID`. The `init` payload identifies the
authenticated user but is not a complete application snapshot.

## Receive Server Events

Server-originated event types conform to `SocketEvent`. Their streams are throwing because decoding failure,
invalidation, and lossless-buffer overflow must reach the consumer.

```swift
let itemEvents = await socketSession.events(for: ItemUpdatedEvent.self)

do {
    for try await item in itemEvents {
        apply(item)
    }
} catch {
    await reloadAffectedRESTSnapshot()
    let replacement = await socketSession.events(for: ItemUpdatedEvent.self)
    consume(replacement)
}
```

Event contracts declare their default delivery policy. Mutation, lifecycle, keyed update, and progress events use
`.lossless`. Replaceable snapshots and explicitly droppable telemetry may use `.latest`.

Override the contract only when the consumer has a deliberate delivery requirement:

```swift
let logs = await socketSession.events(
    for: LogEvent.self,
    policy: try .latest(capacity: 10)
)
```

`.latest` applies to an entire subscription, not to individual entity keys. Do not apply it to mixed item, task, track,
stream, or user progress events. A bounded lossless stream terminates with `SocketIOError.bufferOverflow` rather than
silently dropping an event.

After overflow or decoding termination, treat the affected feature state as potentially desynchronized. Reload its REST
snapshot before opening a replacement event stream because the server provides no replay or missed-event signal.

Transcode lifecycle events are an exception to REST snapshot recovery. `GetOpenSession` confirms that a playback session
exists, but the server response does not include the live transcode stream, reset state, completion state, or failure.
The server provides no other REST endpoint for that state. If `stream_reset` or `stream_error` may have been missed, do
not infer transcode health from the playback session. Recover playback by establishing a new authoritative stream.

## Emit Client Events

Client-originated event types conform to `EmittableSocketEvent`. `ABSSocketSession.emit` accepts only those types.

```swift
try await socketSession.emit(SetLogListenerEvent.self, 2)
try await socketSession.emit(PingEvent.self)
```

Transport reconnect restores Socket.IO event subscriptions, but it does not restore application-level server listeners.
Re-emit commands such as `set_log_listener` after every new authenticated `connectionID` when the feature still needs
them.

## Disconnect and Invalidate

```swift
await socketSession.disconnect()
```

`disconnect()` closes the active transport, clears the server and access token, resets authentication state, and
preserves typed event subscriptions for later reuse.

```swift
await socketSession.invalidate()
```

`invalidate()` publishes `.unauthenticated`, permanently finishes session-owned state observation, and delegates permanent
invalidation to the client. The client finishes event streams with `SocketIOError.invalidated`. Create a new client and
session after invalidation.
