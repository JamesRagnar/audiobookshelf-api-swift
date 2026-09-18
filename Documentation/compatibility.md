# Compatibility

Supported server range: `>= 2.26.0` and `<= 2.36.x`.

`ServerCompatibility` evaluates the overall range. It does not gate individual members, so check the
server version before using anything listed below.

Overall range support does not guarantee identical behavior for every operation across server patch
releases. In particular, callers should check the full server patch version before offering legacy
settings writes or library-scoped narrator mutations.

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
| `GetYourAuthSessions` | — |
| `DeleteYourAuthSession` | — |
| `GetAllMediaProgress` | Read `GetYourUser` instead |
| `GetYourBookmarks` | Read `GetYourUser` instead |
| `GetYourBookmarksForLibraryItem` | — |
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
