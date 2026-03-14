# Audiobookshelf API Swift

A thin Swift client for the Audiobookshelf API, providing async/await request functions and model structs.

## Supported Server Range

**Supported range: `audiobookshelf` `>= 2.26.0` and `<= 2.33.x`**

- **Exception**: `GetSearchProviders` (`/api/search/providers`) requires server `>= 2.31.0`.
- **Deprecated/Removed in package `2.33.0`**: legacy `AuthorizeUser` (`/api/authorize`) wrapper was removed. Use JWT auth endpoints instead.

## Installation

Add this package to your project using Swift Package Manager:

```swift
// In your Package.swift — use the version matching your target server minor
dependencies: [
    .package(
        url: "https://github.com/JamesRagnar/audiobookshelf-api-swift.git",
        .upToNextMinor(from: "1.2.0")
    ),
]
```

Or in Xcode:

1. File → Add Packages…
2. Enter the repository URL: `https://github.com/JamesRagnar/audiobookshelf-api-swift.git`
3. Choose the version you need

## Versioning

This package is a **thin Swift client** for the upstream Audiobookshelf API.
Version numbers are aligned with the corresponding server API version:

```
<server-major>.<server-minor>.<client-patch>
```

* **MAJOR / MINOR** indicate the supported server API version
* **PATCH** releases contain client-side fixes and corrections

Because this package mirrors the server API closely (like an OpenAPI-generated client), upgrades *may* require changes to how the API is used — even on PATCH bumps. Always review release notes for breaking changes.

## Usage

```swift
import AudiobookshelfAPI

let server = ServerConfiguration(
    url: URL(string: "http://localhost:13378")!,
    authToken: "your_api_token"
)

do {
    let item = try await URLSession().dataTask(
        GetLibraryItem.self,
        .init(itemID: "itemID"),
        server
    )
} catch {
    print("Error fetching item:", error)
}
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

Apache License 2.0. See [LICENSE](LICENSE.txt) for details.
