# Media Progress

`MediaProgress` represents the current user's progress for a book or podcast episode. For books, one record holds separate audio (`currentTime`, `duration`) and ebook (`ebookLocation`, `ebookProgress`) positions. Completion, visibility, and timestamps belong to that shared record. Listening sessions are separate history records, not independently addressable ebook progress records.

## Identity and Reads

`id` is the opaque progress-record identifier. `libraryItemId`, `episodeId`, and `mediaItemId` refer to different entities; do not derive one from another. `GetMediaProgress` reads by library-item ID and optional episode ID and maps 404 to `notFound`. `RemoveMediaProgress` takes the progress-record ID and removes the entire combined record, including both positions.

`startedAt` is the response's creation timestamp. Creation requests use `createdAt`. The response's `lastUpdate` describes aggregate record recency, not independent reading and listening times. Timestamps are milliseconds since the POSIX epoch.

## Partial Writes

Single and batch request fields are optional: nil is omitted, while explicit zero and false values are transmitted. For example, a reading update need not supply any audio state:

```swift
let request = PatchMediaProgress.Request(
    libraryItemID: itemID,
    ebookLocation: "epubcfi(/6/2!/4/1:0)",
    ebookProgress: 0.42
)
```

A completion-only request may supply `isFinished` and `finishedAt` while omitting both position families. Both PATCH interfaces have an empty success response. A successful batch response does not provide per-entry receipts or prove that every entry was applied.

The ebook fraction convention is 0 through 1. The server stores a locator string without enforcing an EPUB-specific syntax or attaching a file/edition identifier. `GetEbookFile` selects the current primary ebook when no file inode is supplied; a supplied inode selects that ebook, including a supplementary file. Downloading a selected file does not give it an independent progress record.

## Source-Verified Server Behavior

The following side effects were verified against Audiobookshelf 2.37.2, revision `ce41ce489cebaf00e008919f6f2901b428acfd56`. They are observations about that revision, not additional guarantees for every server version supported by this package.

- Ebook fraction 1 does not itself complete the record. Audio completion rules can still execute on an ebook-only update to an existing mixed-media record.
- Marking finished can set the legacy `progress` value to 1 without moving audio time. It need not equal `currentTime / duration`.
- Transitioning a finished record to unfinished clears audio time and discards a `currentTime` supplied in that same update. Changing audio time later can clear shared completion again.
- Direct progress PATCH does not reject stale writes. On existing records a supplied valid `lastUpdate` can replace aggregate update time. Creation does not consume that field in the same way.
- `markAsFinishedPercentComplete` uses percent units; `markAsFinishedTimeRemaining` uses seconds. A positive percent setting takes precedence. The checked implementation compares the threshold strictly against a clamped audio fraction, so 100 suppresses automatic audio completion on that direct update. Session-sync endpoints use their own library-defined controls.
- Reading PATCH emits `user_updated`; audio session synchronization emits `user_item_progress_updated`. Their payloads expose no per-field revision or causal operation token.

Sources: [serialization and update rules](https://github.com/advplyr/audiobookshelf/blob/ce41ce489cebaf00e008919f6f2901b428acfd56/server/models/MediaProgress.js), [record selection and creation](https://github.com/advplyr/audiobookshelf/blob/ce41ce489cebaf00e008919f6f2901b428acfd56/server/models/User.js), [progress endpoints and batch handling](https://github.com/advplyr/audiobookshelf/blob/ce41ce489cebaf00e008919f6f2901b428acfd56/server/controllers/MeController.js), [file selection](https://github.com/advplyr/audiobookshelf/blob/ce41ce489cebaf00e008919f6f2901b428acfd56/server/controllers/LibraryItemController.js), and [audio session updates](https://github.com/advplyr/audiobookshelf/blob/ce41ce489cebaf00e008919f6f2901b428acfd56/server/managers/PlaybackSessionManager.js).

The package describes and encodes this contract. Applications own local state, completion policy, position reconciliation, retries, and any compensating requests. See [compatibility](compatibility.md) for endpoint availability across supported server versions.
