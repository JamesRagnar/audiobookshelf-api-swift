# Compatibility

`AudiobookshelfAPI` tracks a tested compatibility range for `audiobookshelf` server versions.

## Supported Range

- Supported server range: `>= 2.26.0` and `<= 2.36.x`
- Exception: `GetSearchProviders` requires server `>= 2.31.0`

## Deliberate Gaps

These server routes exist but are not wrapped:

- `POST /api/authorize` — still served, but returns the same payload as `Login`. Use `Login` or
  `RefreshToken`.
- `GET /auth/openid`, `GET /auth/openid/callback`, `GET /auth/openid/mobile-redirect`,
  `GET /auth/openid/config` — the OIDC flow is browser-driven and belongs in a web auth session.
- `/api/internal-api/*` and the Next.js client routes — server-internal.

Socket events that the server removed at or before 2.26.0 are not represented at all, since they can
never fire on a supported server: `audio_metadata_started`, `audio_metadata_finished`,
`audiofile_metadata_started`, `audiofile_metadata_finished`, `authors_added`, `daily_logs`,
`fetch_daily_logs`, `episode_download_queue_updated`, `invalid_token`, `multiple_series_added`,
`scan_start`, `scan_complete`, `stream_open`, `stream_closed`, `stream_progress`, `stream_ready`,
`stream_error`.

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

## Known Gaps

### Status Code Coverage

`responseCases` was audited against the 2.36.0 handler chains, including controller middleware.
Roughly 100 endpoints outside the authentication, session, library-browsing and podcast paths still
omit status codes their handlers can return, mostly `403` and `400` raised by middleware before the
handler runs. Those responses surface as an untyped `unknownResponseCase` rather than a typed error;
they do not cause decode failures. The audited and corrected paths are covered by
`ServerContractAuditTests`.

### Model Nullability

Field-level nullability was verified against the server for the audio, podcast-feed and user models.
Other models are covered at the shape level only: their field sets match, but individual fields may
be typed as non-optional where the server can emit null.

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
- `PodcastEpisodeEnclosure.type` and `PodcastEpisodeEnclosure.length` became easy to encounter as
  null. The emitted shape did not change; see "Corrected Package Bugs" below.
- `DownloadMultipleLibraryItems` returns 403 when the user lacks access to any requested item.
- `DeleteUser` returns 403 rather than 400 when the target is the root user.

## Corrected Package Bugs

These fields were typed as non-optional but the server has always been able to emit null for them.
They were package bugs, not server changes, and every one predates the minimum supported server
version of 2.26.0. They are listed here so the optionality is not mistaken for a 2.36.0 change.

| Field | Server has emitted null since |
| --- | --- |
| `AudioFile.channels`, `AudioFile.channelLayout` | 0.9.61-beta |
| `AudioFile.ino` | 2.0.1 |
| every `PodcastFeedMetadata` field except `categories` | 2.0.1 |
| `AudioFile.duration`, `AudioTrack.duration` | 2.1.0 |
| `AudioFile.timeBase` | 2.2.12 |
| `PodcastEpisodeEnclosure.type`, `PodcastEpisodeEnclosure.length` | 2.18.0 |

The audio fields trace back to ffprobe output that the server stores as null when a stream does not
report the value, so any library containing a file ffprobe could not fully measure would have failed
to decode.

`PodcastEpisodeEnclosure` is the one with a 2.36.0 angle, and only for how easily the null is
reached. Before 2.36.0 an enclosure could only be populated by RSS ingest, where feeds almost always
carry a type and length. 2.36.0 added the `enclosure` field on `UpdatePodcastEpisode`, which accepts
a URL with neither, so nulls can now be written deliberately.

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
