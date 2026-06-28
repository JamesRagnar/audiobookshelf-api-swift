# Audiobookshelf API Swift

`AudiobookshelfAPI` is a Swift Package for integrating Apple-platform apps with the `audiobookshelf` server API. It provides typed REST interface definitions, shared payload models, server compatibility helpers, and socket support for realtime updates.

## What This Package Provides

- Typed request/response interfaces for the REST API
- Shared models for REST and socket payloads
- Runtime server compatibility checks
- Socket.IO auth/session wrapper for typed event streams
- Swift 6 package with Apple platform support

## Package Structure

- `Sources/AudiobookshelfAPI/Interfaces/`: typed endpoint wrappers
- `Sources/AudiobookshelfAPI/Models/`: shared response and payload models
- `Sources/AudiobookshelfAPI/Socket/`: realtime socket types and `ABSSocketSession`
- `Sources/AudiobookshelfAPI/Compatibility/`: server compatibility helpers

## Why Use It

- Keeps API integration typed and explicit
- Centralizes endpoint paths, parameters, and response handling
- Reduces ad hoc decoding and transport glue in app code
- Supports both request/response and realtime integration patterns

## Supported Server Range

**Supported range: `audiobookshelf` `>= 2.26.0` and `<= 2.35.x`**

- `GetSearchProviders` (`/api/search/providers`) requires server `>= 2.31.0`
- Legacy `AuthorizeUser` (`/api/authorize`) was removed from the package for server `>= 2.33.0`

Use `ServerCompatibility` to gate behavior at runtime:

```swift
import AudiobookshelfAPI

switch ServerCompatibility.evaluate(serverVersion: status.serverVersion) {
case .supported:
    break
case .belowMinimum:
    // Require a newer audiobookshelf server
case .aboveTestedRange:
    // Newer server version; proceed carefully
case .unknownVersionFormat:
    // Could not parse server version
}
```

## Requirements

- Swift 6.0+
- iOS 16+, macOS 13+, tvOS 16+, watchOS 9+, visionOS 1+
- An `audiobookshelf` server in the supported range

## Installation

Add the package with Swift Package Manager:

```swift
dependencies: [
    .package(
        url: "https://github.com/JamesRagnar/audiobookshelf-api-swift.git",
        from: "3.0.0"
    )
]
```

Then add the product to your target:

```swift
dependencies: [
    .product(name: "AudiobookshelfAPI", package: "audiobookshelf-api-swift")
]
```

Or in Xcode:

1. Open **File** → **Add Packages…**
2. Enter `https://github.com/JamesRagnar/audiobookshelf-api-swift.git`
3. Select the package version you need

## Usage

```swift
import AudiobookshelfAPI
import RagnarNetworking

let client = APIClient(
    baseURL: URL(string: "http://localhost:13378")!,
    token: { myAuthService.accessToken },
    refresh: { try await myAuthService.refresh() }
)

let status = try await client.send(
    CheckServerStatus.self,
    .init()
)

let item = try await client.send(
    GetLibraryItem.self,
    .init(libraryItemId: "item-id")
)
```

See the guides in `Documentation/` for request flow, compatibility handling, socket integration, and package architecture.

## Documentation

- Documentation index: `Documentation/README.md`
- Architecture overview: `Documentation/architecture.md`
- Request guide: `Documentation/requests.md`
- Compatibility guide: `Documentation/compatibility.md`
- Socket guide: `Documentation/sockets.md`

## License

Apache License 2.0. See `LICENSE.txt`.
