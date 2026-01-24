# Audiobookshelf API Swift

A thin Swift client for the Audiobookshelf API, providing async/await request functions and model structs.

## Installation

Add this package to your project using Swift Package Manager:

```swift
// In your Package.swift
dependencies: [
    .package(
        url: "https://github.com/JamesRagnar/audiobookshelf-api-swift.git",
        from: "1.0.0"
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

let client = AudiobookshelfClient(baseURL: URL(string: "http://localhost:13378")!, token: "your_api_token")

Task {
    do {
        let books = try await client.fetchBooks()
        print(books)
    } catch {
        print("Error fetching books:", error)
    }
}
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

MIT License. See [LICENSE](LICENSE.txt) for details.
