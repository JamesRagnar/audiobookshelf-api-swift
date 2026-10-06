# Compatibility

Supported server range: `>= 2.26.0` and `<= 2.37.x`.

`ServerCompatibility` evaluates the overall range. It does not gate individual members, so check the
server version before using anything listed below.

Overall range support does not guarantee identical behavior for every operation across server patch
releases. In particular, callers should check the full server patch version before offering legacy
settings writes or library-scoped narrator mutations.

## 2.37.0 and 2.37.1

API-key JWT socket authentication and Audible external-book explicit flags start at 2.37.0.
Access tokens remain supported; refresh tokens are not socket credentials.
External-book explicit is optional, with missing/null meaning unknown.

Local cover PATCH still selects an image path. On 2.37.0+ its normalized path must match
metadata.path of a scanned file belonging to the item. URL download uses POST with url;
image bytes use a multipart POST part named cover.

Resized/cached artwork identifiers must be UUIDs. Invalid/nonpositive requested dimensions
become unspecified; positive values clamp to 4096. The cache defaults missing width to 400,
uses proportional height when omitted, and requires positive safe integer dimensions with
webp/jpeg/png. Raw requests bypass resized-cache handling. Existing query serialization is
unchanged. Library-cover accelerated delivery retains its 204 response mapping.

2.37.1 introduces no additional package-exposed response shape changes.

## 2.33.2

Share playback sessions first include optional coverAspectRatio: 0 rectangular, 1 square.
Ordinary sessions omit it; older and null values decode as nil.

## 2.32.0

External-book tags change from comma-separated strings to string arrays. Both representations
remain supported; unrelated types fail decoding. Provider publishedYear remains normalized
from either a string or integer.

## 2.30.0

Streaming cover-search commands and events become available, including SearchCoversEvent,
CancelCoverSearchEvent, CoverSearchResult, CoverSearchComplete and CoverSearchError.
Their payload shapes are unchanged.

## 2.26.0 maintained-range corrections

The corrected REST contracts apply across 2.26.0...2.37.1.
They are not operations newly introduced in 2.37. Nullable ownership, ISO share/API-key dates,
RSS episode normalization, write shapes, logger/task models and separate year statistics are
maintained-range corrections. No transport fallback, OIDC wrapper or auth-flow implementation is added.

## 2.36.1

The server silently ignores these seven legacy `/api/settings` properties while returning HTTP 200:
`metadataFileFormat`, `rateLimitLoginRequests`, `rateLimitLoginWindow`, `backupPath`,
`loggerDailyLogsToKeep`, `loggerScannerLogsToKeep`, and `podcastEpisodeSchedule`. A nil property is
omitted by the client. A non-nil legacy property is still encoded and sent. Deprecation does not
suppress transmission, and HTTP 200 does not prove that a supplied setting changed.

The typed media payload omits `ebookFile`, `chapters`, and `audioFiles`; those remain response fields.
This client-side omission is separate from the server ignoring those fields if another client sends
them. Chapter writes use `UpdateLibraryItemChapters`.

Resized artwork accepts `webp`, `jpeg`, and `png`. Auth custom messages are sanitized by the server,
so the returned value may differ from submitted HTML. Missing-share requests require the session
cookie obtained through `GetMediaShare`. Narrator mutations are library-isolated on v2.36.1; older
supported servers may affect matching narrators in other libraries.

## 2.36.0

Added. On older servers the endpoint does not exist unless noted.

| Member | Older servers |
| --- | --- |
| `GetYourAuthSessions` | Unavailable |
| `DeleteYourAuthSession` | Unavailable |
| `GetAllMediaProgress` | Read `GetYourUser` instead |
| `GetYourBookmarks` | Read `GetYourUser` instead |
| `GetYourBookmarksForLibraryItem` | Unavailable |
| `UpdatePassword(refreshToken:)` | Header ignored; `Response.user` is nil and the caller is logged out |
| `Logout(allDevices:)` | Parameter ignored; only the current session is logged out |
| `ServerSettings.timeZone` | Null |
| `UpdatePodcastEpisode` `enclosure` | Field ignored |
| `AuthorsNumBooksUpdatedEvent` | Never emitted |

Changed.

- `UpdatePassword` destroys the user's other authentication sessions. Pass `refreshToken` to keep the
  calling session alive and receive rotated tokens; otherwise the caller is logged out too.
- Refresh tokens no longer authenticate REST or socket requests. Use access tokens.
- The refresh token grace period is 10 minutes, up from 1. Retrying a refresh with a superseded token
  returns the already-rotated pair instead of failing.
- Expanded library item JSON is now a superset of minified. `LibraryItem.numFiles`, `Book.numTracks`,
  `Book.numAudioFiles`, `Book.numChapters`, `Book.ebookFormat`, `Podcast.numEpisodes` and
  `Podcast.size` are populated on expanded responses and `item_updated` payloads, where they were
  previously null.
- `UpdatePodcastEpisode` can set an enclosure with no type or length, so
  `PodcastEpisodeEnclosure.type` and `PodcastEpisodeEnclosure.length` are easier to encounter as null.
- `DownloadMultipleLibraryItems` returns 403 when the user lacks access to any requested item.
- `DeleteUser` returns 403 rather than 400 when the target is the root user.

## 2.31.0

| Member | Older servers |
| --- | --- |
| `GetSearchProviders` | Endpoint does not exist |

## Runtime Evaluation

Use `ServerCompatibility` with the server version returned by `CheckServerStatus`.

```swift
import AudiobookshelfAPI

switch ServerCompatibility.evaluate(serverVersion: status.serverVersion) {
case .supported:
    break
case .belowMinimum:
    // Older than the minimum supported version
case .aboveTestedRange:
    // Newer than the tested range
case .unknownVersionFormat:
    // Version string could not be parsed
}
```
