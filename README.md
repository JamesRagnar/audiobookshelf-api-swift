# Audiobookshelf API Swift

A thin Swift client for the Audiobookshelf API, providing async/await request functions and model structs.

## Supported Server Range

**Supported range: `audiobookshelf` `>= 2.26.0` and `<= 2.35.x`**

- **Exception**: `GetSearchProviders` (`/api/search/providers`) requires server `>= 2.31.0`.
- **Removed in server `2.33.0`**: legacy `AuthorizeUser` (`/api/authorize`) endpoint was removed. Use JWT auth endpoints instead.

Use `ServerCompatibility` to evaluate a server version string at runtime before making requests:

```swift
switch ServerCompatibility.evaluate(serverVersion: status.serverVersion) {
case .supported:
    // proceed
case .belowMinimum:
    // tell the user to upgrade their server
case .aboveTestedRange:
    // newer server — requests may still work, but warn the user
case .unknownVersionFormat:
    // could not parse the version string
}
```

## Installation

Add this package to your project using Swift Package Manager:

```swift
dependencies: [
    .package(
        url: "https://github.com/JamesRagnar/audiobookshelf-api-swift.git",
        from: "3.0.0"
    ),
]
```

Or in Xcode:

1. File → Add Packages…
2. Enter the repository URL: `https://github.com/JamesRagnar/audiobookshelf-api-swift.git`
3. Choose the version you need

## Usage

### HTTP requests

Create an `APIClient` (from `RagnarNetworking`) and call `send(_:_:)` with any `Interface` type:

```swift
import AudiobookshelfAPI

let client = APIClient(
    baseURL: URL(string: "http://localhost:13378")!,
    token: { myAuthService.accessToken },
    refresh: { try await myAuthService.refresh() }
)

// Check server status (no auth required)
let status = try await client.send(CheckServerStatus.self, .init())

// Fetch a library item
let item = try await client.send(GetLibraryItem.self, .init(libraryItemId: "item-id"))
```

### Socket events

Use `ABSSocketSession` to connect to the server's Socket.IO endpoint and receive typed events.
The session handles the ABS auth handshake automatically on every (re)connect.

```swift
let socketClient = SocketIOClient()
let session = ABSSocketSession(client: socketClient)

// Connect with a JWT
await session.connect(to: serverURL, token: accessToken)

// Observe auth state
for await state in await session.authStateUpdates() {
    switch state {
    case .authenticated(let userID, _): print("Authenticated as \(userID)")
    case .failed(let message): print("Auth failed: \(message)")
    default: break
    }
}

// Subscribe to typed events
for await event in await session.events(for: ItemsUpdatedEvent.self) {
    print("Items updated: \(event.map(\.id))")
}
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

Apache License 2.0. See [LICENSE](LICENSE.txt) for details.
