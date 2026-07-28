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

Each name above was verified absent from `server/` at every tag in the supported range. Absence was
checked by looking for the event name at the tag itself, not by reading `git log -S` history, which
reports where an occurrence count last changed rather than where something was removed.

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

Middleware-raised codes are complete. Every interface was matched to its 2.36.0 route and the
middleware in that route's chain, and the codes each middleware can raise were derived per route
rather than per controller, because most of them are conditional:

- `AuthorController`, `SeriesController`, `SessionController` and `CollectionController` raise `403`
  only on write methods, so a `GET` through them cannot produce one.
- `BackupController`, `ToolsController`, `NotificationController`, `UserController` and others guard
  their `404` behind `req.params.id`, so collection routes cannot produce one.
- `EmailController.adminMiddleware` answers `404`, not `403`, when the user is not an admin.

That matching covered 212 of the 215 interfaces; the remaining three (`CheckServerStatus`,
`Healthcheck`, `PingServer`) are registered on the app rather than a router. 126 interfaces sit
behind middleware, and 43 of them were missing at least one code it can raise. All 43 are fixed, and
`MiddlewareStatusCodeCoverageTests` pins them.

Handler-raised codes are a different matter and are **not** complete. Codes returned by the route
handler itself, after middleware passes, were only audited on the authentication, session,
library-browsing and podcast paths. Elsewhere a handler-specific `400` or `500` may still be
unmapped. Those surface as an untyped `unknownResponseCase` rather than a typed error; they do not
cause decode failures.

### Model Nullability

Field-level nullability was verified against the server for the audio, podcast-feed and user models.
Other models are covered at the shape level only: their field sets match, but individual fields may
be typed as non-optional where the server can emit null.

## Behavior Changes By Version

These do not change any Swift type, but they change what a call does.

### 2.36.0

- A successful `UpdatePassword` destroys every other authentication session for the user. Pass
  `refreshToken` to keep the calling session alive and receive rotated tokens; without it, or when
  the token no longer matches a live session, the caller is logged out too. `Response.user` is nil in
  that case, and the endpoint answers with a non-JSON body that the interface's response handler
  resolves rather than surfacing as a decode failure.
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

### Handling a null `duration`

`AudioFile.duration` and `AudioTrack.duration` need more than optionality to use safely, because a
null does not just mean "unknown" — it means the item's timeline is wrong on the server.

The chain, unchanged across the whole supported range:

- `utils/prober.js` sets `duration` to null whenever ffprobe reports no usable `format.duration`.
  There is no fallback to the audio stream's own duration.
- `scanner/AudioFileScanner.js` rejects a file only when ffprobe errors or finds no audio stream. It
  never checks duration, so the file is accepted and persisted to a JSON column as null.
- `models/Book.js` builds the track list with `startOffset += track.duration`. In JavaScript a null
  adds zero, so the null track and the track after it report the same `startOffset`, and every later
  offset is short by the null track's real length.
- The scanner's `!isNaN(af.duration)` guard does not filter null either, since `isNaN(null)` is
  false. The media's total duration is therefore short by the same amount.
- `hasAudioTracks` only counts files, so the server still presents the item as playable.

Concretely, three files of 100s, null and 50s produce tracks at offsets 0, 100 and 100, and a total
duration of 150 rather than 250.

Because the key is emitted as an explicit `null` rather than omitted, the previous non-optional type
did not degrade — it threw `valueNotFound` and took the entire enclosing `LibraryItem` decode with
it. One unmeasurable file made the whole item unfetchable.

Recommended handling:

- Do not substitute zero. That reproduces the server's corruption client-side and hides it, and any
  progress written against those offsets propagates the error back to the server and to other
  devices.
- Refuse playback when a null-duration track is followed by another track. No correct timeline can
  be reconstructed from the response.
- A null on a single-track item, or on the last track, leaves every offset that matters intact. Play
  it and take the real duration from the decoded asset rather than trusting the server's total.
- The underlying fix is server-side: the file needs re-scanning or re-encoding.

These were wrong in ways optionality does not describe, and are also corrected here:

| Member | Was | Now |
| --- | --- | --- |
| `ExternalAuthorSearchResult.imageUrl` | never populated; the server sends `image` | renamed to `image` |
| `GetCustomMetadataProviders.providers` | `[CustomMetadataProvider]`, which requires `slug` and always failed to decode | `[StoredCustomMetadataProvider]`, the row the server actually sends |
| `UpdateAPIKey` body | sent `expiresAt`, which the server ignores | sends `isActive` and `userId` |
| `CreatePodcastFromFeed` | named as if it created a podcast; it only parses a feed | renamed to `GetPodcastFeed`, old name deprecated |

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
