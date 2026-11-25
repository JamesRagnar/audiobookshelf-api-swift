# Release Notes

## Unreleased

Added Audiobookshelf 2.38 compatibility, typed progress-write access denial, and nullable permission-filtered collection mutation responses. Updated socket audience and permission guidance. Maintained server range is 2.26.0 through 2.38.x.

### Breaking Public API Changes

The response type changed from `Collection` to `Collection?` for these six interfaces:

- `CreateCollection`
- `UpdateCollection`
- `CollectionAddBook`
- `CollectionRemoveBook`
- `CollectionBatchAddBooks`
- `CollectionBatchRemoveBooks`

Unwrap a returned collection before use. Handle nil as successful completion without a visible
collection representation, rather than a mutation failure. On server 2.38.0+, a nonempty collection
with no books visible under the requesting user's tag and explicit-content permissions returns JSON
`null`. Partially visible collections contain only visible books. A genuinely empty collection still
returns an object with an empty books array.

```swift
let collection = try await client.send(
    CollectionAddBook.self,
    .init(collectionID: collectionID, bookID: bookID)
)
if let collection {
    showCollection(collection)
} else {
    // The mutation succeeded without a visible collection representation.
    showMutationCompleted()
}
```
