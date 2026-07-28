# Compatibility

Supported server range: `>= 2.26.0` and `<= 2.36.x`.

`ServerCompatibility` evaluates the overall range. It does not gate individual members, so check the
server version before using anything listed below.

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
