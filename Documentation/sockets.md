# Sockets

`AudiobookshelfAPI` includes `ABSSocketSession` for integrating with audiobookshelf realtime events over Socket.IO.

## Purpose

`ABSSocketSession` wraps any `SocketClient` from `RagnarNetworking` and handles the audiobookshelf auth handshake on connect and reconnect.

It is useful when your app needs:

- item and library update events
- playback-related realtime updates
- a typed event-stream API over Socket.IO

## Basic Setup

```swift
import AudiobookshelfAPI
import RagnarNetworking

let socketClient = SocketIOClient()
let session = ABSSocketSession(client: socketClient)

await session.connect(to: serverURL, token: accessToken)
```

## Auth State

`ABSSocketSession` tracks auth state separately from raw transport state.

```swift
for await state in await session.authStateUpdates() {
    switch state {
    case .authenticated(let userID, let username):
        print("Authenticated as \(userID) / \(username)")
    case .failed(let message):
        print("Socket auth failed: \(message)")
    default:
        break
    }
}
```

## Event Streams

Use typed socket event streams for server events:

```swift
for await event in await session.events(for: ItemsUpdatedEvent.self) {
    print(event)
}
```

The session delegates event streams to the underlying socket transport, so subscriptions survive reconnects without requiring re-registration in normal use.

## Token Updates

If your app refreshes its auth token while connected, update the session token:

```swift
await session.updateToken(newAccessToken)
```

The session re-emits the auth event when appropriate.

## Disconnect Behavior

```swift
await session.disconnect()
```

Disconnect resets session auth state while preserving the application-owned socket session object for later reuse.

## Integration Guidance

- Own a `SocketClient` implementation at the application boundary
- Treat `ABSSocketSession` as the audiobookshelf-specific socket layer
- Keep token refresh and reconnect policy in app-level infrastructure
- Use typed event consumers instead of stringly-typed event dispatch in feature code
