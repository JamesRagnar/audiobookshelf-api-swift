# Architecture

`AudiobookshelfAPI` is a typed API surface, not a full networking stack.

## Responsibilities

The package is responsible for:

- defining typed request interfaces for `audiobookshelf` endpoints
- defining shared response and event models
- defining response mappings for expected server outcomes
- exposing compatibility helpers for server-version gating
- providing socket helpers for audiobookshelf-specific realtime flows

The package is not responsible for:

- owning your application authentication state
- owning request execution infrastructure
- deciding application-level retry policy or UI behavior

## System Boundaries

### `AudiobookshelfAPI`

- owns endpoint definitions and payload models
- knows server paths, parameters, and response expectations
- keeps integration logic centralized and typed

### `RagnarNetworking`

- owns request transport and socket transport primitives
- provides `APIClient`, `SocketIOClient`, and shared networking protocols
- executes the interfaces defined by this package

### Your app

- owns base URL configuration
- owns access-token and refresh-token lifecycle
- decides how to react to compatibility, auth, and domain errors

## Source Layout

- `Sources/AudiobookshelfAPI/Interfaces/`: endpoint wrappers grouped by domain
- `Sources/AudiobookshelfAPI/Models/`: shared API models
- `Sources/AudiobookshelfAPI/Socket/`: socket event types and `ABSSocketSession`
- `Sources/AudiobookshelfAPI/Compatibility/`: server-version helpers

## Integration Model

Typical integration flow:

1. Build an `APIClient` in your app using `RagnarNetworking`
2. Use `CheckServerStatus` to inspect server state and version
3. Evaluate compatibility with `ServerCompatibility`
4. Authenticate using the supported auth endpoints
5. Execute request interfaces as needed
6. Optionally attach socket flows with `ABSSocketSession`

## Design Goal

The package is intended to keep `audiobookshelf` integration explicit, typed, and reusable across applications without forcing a specific app architecture.
