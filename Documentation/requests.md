# Requests

`AudiobookshelfAPI` defines typed REST interfaces. Request execution is handled by `RagnarNetworking`.

## Basic Request Flow

```swift
import AudiobookshelfAPI
import RagnarNetworking

let client = APIClient(
    baseURL: URL(string: "http://localhost:13378")!,
    token: { authStore.accessToken },
    refresh: { try await authStore.refresh() }
)

let status = try await client.send(CheckServerStatus.self, .init())
let item = try await client.send(GetLibraryItem.self, .init(libraryItemId: "item-id"))
```

## Authentication Model

- Interfaces that do not require authentication use `authentication: .none`
- Authenticated interfaces use bearer token authentication
- Token and refresh behavior are supplied by your `APIClient` configuration

Typical startup flow:

1. Call `CheckServerStatus`
2. Evaluate `ServerCompatibility`
3. Authenticate with `Login` or `RefreshToken`
4. Execute authenticated interfaces through `APIClient`

## Interface Pattern

Each endpoint wrapper defines:

- request method
- path and query items
- authentication requirement
- response body type
- expected response mappings

This keeps transport code generic while endpoint behavior stays typed and centralized.

## Error Handling

Each interface declares its expected `responseCases`. That allows known status codes to decode into either typed responses or mapped errors.

Unknown or unmapped outcomes surface through the underlying `RagnarNetworking` error handling.

## Binary and No-Content Endpoints

Some interfaces return raw `Data` for file and media endpoints.

Some interfaces return `EmptyResponse` for successful no-body operations. These use `.noContent` response mappings where appropriate.

## Practical Guidance

- Keep `APIClient` ownership in your application layer
- Centralize auth token refresh in one place
- Use interface types directly instead of building endpoint strings in app code
- Gate version-sensitive behavior through `ServerCompatibility`
