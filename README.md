# Audiobookshelf API Swift

A thin Swift client for the Audiobookshelf API, providing async/await request functions and model structs.

## Supported Server Range

**Supported range: `audiobookshelf` `>= 2.26.0` and `<= 2.35.1`**

- **Exception**: `GetSearchProviders` (`/api/search/providers`) requires server `>= 2.31.0`.
- **Removed in server `2.33.0`**: legacy `AuthorizeUser` (`/api/authorize`) endpoint was removed. Use JWT auth endpoints instead.

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
