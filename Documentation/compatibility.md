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
`scan_start`, `scan_complete`.

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
| `UpdatePassword(refreshToken:)` | Header ignored; `Response.user` is always nil and the caller is logged out |
| `Logout(allDevices:)` | Parameter ignored, only the current session is logged out |
| `ServerSettings.timeZone` | Null |
| `UpdatePodcastEpisode` `enclosure` | Field ignored by the server |
| `AuthorsNumBooksUpdatedEvent` | Event is never emitted |

## Known Gaps

### Status Code Coverage

Codes raised by route middleware are complete against 2.36.0, and pinned by
`MiddlewareStatusCodeCoverageTests`.

Codes raised by the route handler itself are audited only on the authentication, session,
library-browsing and podcast paths. Elsewhere a handler-specific `400` or `500` may be unmapped.
Unmapped codes surface as `unknownResponseCase`; they do not cause decode failures.

### Model Nullability

Field-level nullability was verified against the server for the audio, podcast-feed and user models.
Other models are covered at the shape level only: their field sets match, but individual fields may
be typed as non-optional where the server can emit null.

## Behavior Changes By Version

These do not change any Swift type, but they change what a call does.

### 2.36.0

- A successful `UpdatePassword` destroys every other authentication session for the user. Pass
  `refreshToken` to keep the calling session alive and receive rotated tokens. Without it, or when
  the token no longer matches a live session, the caller is logged out too and `Response.user` is
  nil. The server answers that case with a non-JSON body, which the interface's response handler
  resolves.
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
- `DeleteUser` returns 403 rather than 400 when the target is the root user. It still returns 400
  when you attempt to delete yourself.

## Corrected Package Bugs

These fields were typed as non-optional but the server has always been able to emit null for them.
Package bugs, not server changes; every one predates 2.26.0. The key is emitted as an explicit
`null`, so the previous types threw `valueNotFound` and failed the enclosing decode.

| Field | Server has emitted null since |
| --- | --- |
| `AudioFile.channels`, `AudioFile.channelLayout` | 0.9.61-beta |
| `AudioFile.ino` | 2.0.1 |
| every `PodcastFeedMetadata` field except `categories` | 2.0.1 |
| `AudioFile.duration`, `AudioTrack.duration` | 2.1.0 |
| `AudioFile.timeBase` | 2.2.12 |
| `PodcastEpisodeEnclosure.type`, `PodcastEpisodeEnclosure.length` | 2.18.0 |

The audio fields come from ffprobe output the server stores as null when a stream does not report the
value.

These were wrong in ways optionality does not describe, and are also corrected:

| Member | Was | Now |
| --- | --- | --- |
| `ExternalAuthorSearchResult.imageUrl` | never populated; the server sends `image` | renamed to `image` |
| `GetCustomMetadataProviders.providers` | `[CustomMetadataProvider]`; the `slug` it requires is never sent, so every call failed to decode | `[StoredCustomMetadataProvider]` |
| `UpdateAPIKey` body | sent `expiresAt`, which the server ignores | sends `isActive` and `userId` |
| `CreatePodcastFromFeed` | the endpoint parses a feed, it does not create a podcast | renamed to `GetPodcastFeed`, old name deprecated |

### Handling a null `duration`

A null `AudioFile.duration` or `AudioTrack.duration` means the item's timeline is wrong on the
server, not that the length is merely unknown. The behavior is unchanged across the supported range:

- The scanner accepts any file with a readable audio stream and does not require a duration, so the
  null persists until the file is re-scanned or re-encoded.
- The track list accumulates with `startOffset += track.duration`, where a null adds zero. The null
  track and the one after it report the same `startOffset`, and every later offset is short by the
  null track's real length.
- The media's total duration is short by the same amount.
- The item is still reported as playable.

Three files of 100s, null and 50s produce offsets 0, 100 and 100, and a total duration of 150.

Handling:

- Refuse playback when a null-duration track is followed by another track. No correct timeline can be
  reconstructed from the response.
- A null on a single-track item or on the last track leaves the offsets intact. Read the real
  duration from the decoded asset rather than the server total.
- Do not substitute zero. That reproduces the server's offsets, and progress written against them
  syncs back to the server and other devices.

`PodcastEpisodeEnclosure` nulls are easier to reach on 2.36.0. Before then an enclosure could only be
populated by RSS ingest, where feeds usually carry a type and length. 2.36.0 added the `enclosure`
field on `UpdatePodcastEpisode`, which accepts a URL with neither.

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
