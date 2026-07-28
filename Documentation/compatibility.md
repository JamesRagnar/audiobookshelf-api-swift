# Compatibility

`AudiobookshelfAPI` tracks a tested compatibility range for `audiobookshelf` server versions.

## Supported Range

- Supported server range: `>= 2.26.0` and `<= 2.36.x`
- Exception: `GetSearchProviders` requires server `>= 2.31.0`
- Legacy `/api/authorize` support is not part of the current package surface

## Version-Gated Surface

Everything below is present in the package but only functional on a server at or above the listed
version. `ServerCompatibility` evaluates the overall range; it does not gate individual members, so
check the server version before using these.

### Requires `>= 2.31.0`

| Member | Behavior on older servers |
| --- | --- |
| `GetSearchProviders` | Endpoint does not exist |

### Requires `>= 2.36.0`

| Member | Behavior on older servers |
| --- | --- |
| `GetYourAuthSessions` | Endpoint does not exist |
| `DeleteYourAuthSession` | Endpoint does not exist |
| `GetAllMediaProgress` | Endpoint does not exist; read `GetYourUser` instead |
| `GetYourBookmarks` | Endpoint does not exist; read `GetYourUser` instead |
| `GetYourBookmarksForLibraryItem` | Endpoint does not exist |
| `UpdatePasswordWithTokenRotation` | Empty response body, which fails to decode; use `UpdatePassword` |
| `Logout(allDevices:)` | Parameter ignored, only the current session is logged out |
| `ServerSettings.timeZone` | Null |
| `UpdatePodcastEpisode` `enclosure` | Field ignored by the server |
| `AuthorsNumBooksUpdatedEvent` | Event is never emitted |

## Behavior Changes By Version

These do not change any Swift type, but they change what a call does.

### 2.36.0

- A successful `UpdatePassword` destroys every authentication session for the user, including the
  calling one. Use `UpdatePasswordWithTokenRotation` to keep the current session alive.
- Refresh tokens are rejected as bearer credentials on both REST and socket authentication. Only
  access tokens authenticate requests.
- The refresh token grace period after rotation is 10 minutes, up from 1 minute. Retrying a refresh
  with a superseded token returns the already-rotated pair rather than failing.
- Expanded item JSON became a strict superset of minified item JSON. `LibraryItem.numFiles`,
  `Book.numTracks`, `Book.numAudioFiles`, `Book.numChapters`, `Book.ebookFormat`,
  `Podcast.numEpisodes` and `Podcast.size` are now populated on expanded responses and on
  `item_updated` socket payloads, where they were previously null.
- `PodcastEpisodeEnclosure.type` and `PodcastEpisodeEnclosure.length` can be null, because an
  enclosure can now be set with only a URL.
- `DownloadMultipleLibraryItems` returns 403 when the user lacks access to any requested item.
- `DeleteUser` returns 403 rather than 400 when the target is the root user.

## Runtime Evaluation

Use `ServerCompatibility` with the server version returned by `CheckServerStatus`.

```swift
import AudiobookshelfAPI

switch ServerCompatibility.evaluate(serverVersion: status.serverVersion) {
case .supported:
    break
case .belowMinimum:
    // Require a newer server
case .aboveTestedRange:
    // Newer server; allow with caution if your product chooses to
case .unknownVersionFormat:
    // Could not parse version string
}
```

## Result Semantics

- `.supported`: the server is within the package's tested range
- `.belowMinimum`: the server is older than the minimum supported version
- `.aboveTestedRange`: the server is newer than the package's tested range
- `.unknownVersionFormat`: the server version string could not be parsed

## Recommended Product Behavior

- Block integration on `.belowMinimum`
- Warn or soft-gate on `.aboveTestedRange` if your app supports cautious forward use
- Treat `.unknownVersionFormat` as an operational compatibility warning

## Why This Exists

The `audiobookshelf` server evolves over time, including response-shape and access-control changes. Explicit compatibility handling lets apps make deliberate runtime decisions instead of assuming every server is identical.
