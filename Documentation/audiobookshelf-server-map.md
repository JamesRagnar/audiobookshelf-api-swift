# Audiobookshelf Server Mapping

**Server Version**: audiobookshelf 2.32.1
**Package Version**: audiobookshelf-api-swift 2.32.0
**Last Updated**: 2026-01-29

## Overview

This document provides the authoritative mapping between the audiobookshelf server API and the Swift interface/model implementations. It serves as both a reference for developers and an audit tool for package maintenance.

## How to Use This Document

- **Finding an Endpoint**: Use Section 1 to look up endpoints by category
- **Understanding Server Models**: See Section 2 for server model serialization details
- **Checking Interface Coverage**: Section 3 lists any orphaned/duplicate interfaces
- **Verifying Model Coverage**: Section 4 lists Swift models without server equivalents

---

## Server Endpoint Mapping

### 1. Library Item Endpoints (26 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /api/items/:id | GET | LibraryItem | GetLibraryItem | LibraryItem | Supports `include` and `expanded` params |
| /api/items/:id | DELETE | None | DeleteLibraryItem | EmptyResponse | `hard` param for physical deletion |
| /api/items/:id/download | GET | Binary (zip) | DownloadLibraryItem | Data | Returns file stream |
| /api/items/:id/media | PATCH | LibraryItem | UpdateLibraryItemMedia | LibraryItem | Updates book/podcast metadata |
| /api/items/:id/cover | POST | Cover response | UploadLibraryItemCover | Cover | Uploads image file |
| /api/items/:id/cover | PATCH | Cover response | UpdateLibraryItemCover | Cover | Updates from URL |
| /api/items/:id/cover | DELETE | None | DeleteLibraryItemCover | EmptyResponse | Removes cover |
| /api/items/:id/cover | GET | Image file | GetLibraryItemCover | Data | Image transformation params |
| /api/items/:id/play | POST | PlaybackSession | StartPlaybackSession | PlaybackSession | For books |
| /api/items/:id/play/:episodeId | POST | PlaybackSession | StartEpisodePlaybackSession | PlaybackSession | For podcast episodes |
| /api/items/:id/tracks | PATCH | LibraryItem | UpdateLibraryItemTracks | LibraryItem | Updates audio track order |
| /api/items/:id/match | POST | Match result | MatchLibraryItem | MatchResult | External metadata search |
| /api/items/:id/scan | POST | Scan result | ScanLibraryItem | ScanResult | Rescans file metadata |
| /api/items/:id/metadata-object | GET | Metadata object | GetLibraryItemMetadataObject | MetadataObject | Raw metadata JSON |
| /api/items/:id/chapters | POST | Custom response | UpdateLibraryItemChapters | ChapterUpdateResult | Updates chapter data |
| /api/items/:id/ffprobe/:fileid | GET | FFProbe JSON | GetLibraryItemFFProbe | FFProbeData | Audio file analysis |
| /api/items/:id/file/:fileid | GET | Binary file | GetLibraryFile | Data | Returns single file |
| /api/items/:id/file/:fileid | DELETE | None | DeleteLibraryFile | EmptyResponse | Deletes library file |
| /api/items/:id/file/:fileid/download | GET | Binary file | DownloadLibraryFile | Data | Downloads single file |
| /api/items/:id/ebook/:fileid? | GET | Binary ebook | GetEbookFile | Data | Returns ebook file |
| /api/items/:id/ebook/:fileid/status | PATCH | None | UpdateEbookFileStatus | EmptyResponse | Opens/closes ebook |
| /api/items/batch/delete | POST | None | BatchDeleteLibraryItems | EmptyResponse | Bulk delete |
| /api/items/batch/update | POST | Custom response | BatchUpdateLibraryItems | BatchUpdateResult | Bulk update |
| /api/items/batch/get | POST | LibraryItem array | BatchGetLibraryItems | [LibraryItem] | Returns expanded items |
| /api/items/batch/quickmatch | POST | None (async) | BatchQuickMatchLibraryItems | EmptyResponse | Async metadata match |
| /api/items/batch/scan | POST | None (async) | BatchScanLibraryItems | EmptyResponse | Async file scan |

### 2. User Endpoints (11 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /api/users | POST | User | CreateUser | User | Requires admin |
| /api/users | GET | User array | GetUsers | [User] | `include=latestSession` param |
| /api/users/online | GET | Custom | GetOnlineUsers | OnlineUsers | Active session list |
| /api/users/:id | GET | User + MediaProgress | GetUser | User | Includes progress data |
| /api/users/:id | PATCH | User | UpdateUser | User | Requires admin |
| /api/users/:id | DELETE | Success response | DeleteUser | DeleteUserResponse | Requires admin |
| /api/users/:id/openid-unlink | PATCH | None | UnlinkUserFromOpenID | EmptyResponse | Removes OpenID link |
| /api/users/:id/listening-sessions | GET | PlaybackSession array | GetUserListeningSessions | PaginatedSessions | Paginated results |
| /api/users/:id/listening-stats | GET | Stats object | GetUserListeningStats | ListeningStats | Aggregate stats |
| /api/authorize | POST | User | AuthorizeUser | User | Legacy endpoint |
| /api/users/:id/purge-media-progress | DELETE | None | _(no interface - endpoint not found in server)_ | - | No server endpoint exists |

### 3. Me Endpoints (18 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /api/me | GET | User | GetCurrentUser | User | Current user info |
| /api/me/listening-sessions | GET | PlaybackSession array | GetMyListeningSessions | PaginatedSessions | Current user sessions |
| /api/me/item/listening-sessions/:libraryItemId/:episodeId? | GET | PlaybackSession array | GetItemListeningSessions | PaginatedSessions | Item-specific sessions |
| /api/me/listening-stats | GET | Stats object | GetMyListeningStats | ListeningStats | Current user stats |
| /api/me/progress/:id/:episodeId? | GET | MediaProgress | GetMediaProgress | MediaProgress | Progress for item |
| /api/me/progress/:id | DELETE | None | DeleteMediaProgress | EmptyResponse | Removes progress |
| /api/me/progress/:libraryItemId/:episodeId? | PATCH | None | UpdateMediaProgress | EmptyResponse | Updates progress |
| /api/me/progress/batch/update | PATCH | None | BatchUpdateMediaProgress | EmptyResponse | Bulk progress update |
| /api/me/item/:id/bookmark | POST | Bookmark | CreateBookmark | Bookmark | Adds bookmark |
| /api/me/item/:id/bookmark | PATCH | Bookmark | UpdateBookmark | Bookmark | Updates bookmark |
| /api/me/item/:id/bookmark/:time | DELETE | None | DeleteBookmark | EmptyResponse | Removes bookmark |
| /api/me/password | PATCH | None | UpdatePassword | EmptyResponse | Changes password |
| /api/me/items-in-progress | GET | LibraryItem array | GetItemsInProgress | [LibraryItem] | Minified + episode data |
| /api/me/series/:id/remove-from-continue-listening | GET | User | RemoveSeriesFromContinueListening | User | Hides series |
| /api/me/series/:id/readd-to-continue-listening | GET | User | ReaddSeriesToContinueListening | User | Unhides series |
| /api/me/progress/:id/remove-from-continue-listening | GET | User | RemoveItemFromContinueListening | User | Hides item |
| /api/me/ereader-devices | POST | User | UpdateUserEReaderDevices | User | ✅ Implemented 2026-01-28 |
| /api/me/stats/year/:year | GET | YearStats | GetYearStats | YearStats | User year stats |

### 4. Podcast Endpoints (13 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /api/podcasts | POST | LibraryItem | CreatePodcast | LibraryItem | Returns expanded |
| /api/podcasts/feed | POST | Podcast object | GetPodcastFeed | PodcastFeed | RSS feed data |
| /api/podcasts/opml | POST | Feed array | ParseOPML | [PodcastFeed] | Parses OPML file |
| /api/podcasts/opml/create | POST | None (async) | BulkCreatePodcastsFromOPML | EmptyResponse | Async creation |
| /api/podcasts/:id/checknew | GET | Episode array | CheckForNewPodcastEpisodes | [PodcastEpisode] | `limit` param |
| /api/podcasts/:id/clear-queue | GET | None | ClearEpisodeDownloadQueue | EmptyResponse | Clears download queue |
| /api/podcasts/:id/downloads | GET | Download array | GetEpisodeDownloads | [PodcastEpisodeDownload] | Active downloads |
| /api/podcasts/:id/search-episode | GET | Episode array | SearchPodcastEpisode | [PodcastEpisode] | RSS search |
| /api/podcasts/:id/download-episodes | POST | None (queued) | DownloadPodcastEpisodes | EmptyResponse | Queues downloads |
| /api/podcasts/:id/match-episodes | POST | Update count | QuickMatchPodcastEpisodes | MatchResult | `override` param |
| /api/podcasts/:id/episode/:episodeId | GET | PodcastEpisode | GetPodcastEpisode | PodcastEpisode | Single episode |
| /api/podcasts/:id/episode/:episodeId | PATCH | LibraryItem | UpdatePodcastEpisode | LibraryItem | Returns expanded |
| /api/podcasts/:id/episode/:episodeId | DELETE | LibraryItem | DeletePodcastEpisode | LibraryItem | `hard` param |

### 5. Author Endpoints (7 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /api/authors/:id | GET | Author | GetAuthor | Author | `include=items,series` |
| /api/authors/:id | PATCH | Author | UpdateAuthor | Author | Updates metadata |
| /api/authors/:id | DELETE | None | DeleteAuthor | EmptyResponse | Removes author |
| /api/authors/:id/image | GET | Image file | GetAuthorImage | Data | Image transformation |
| /api/authors/:id/image | POST | Author | UploadAuthorImage | Author | Uploads image |
| /api/authors/:id/image | DELETE | Author | DeleteAuthorImage | Author | Removes image |
| /api/authors/:id/match | POST | Author | MatchAuthor | Author | External search |

### 6. Series Endpoints (2 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /api/series/:id | GET | Series | GetSeriesById | SeriesBooks | `include=progress,rssfeed` |
| /api/series/:id | PATCH | Series | UpdateSeries | SeriesBooks | Updates metadata |

### 7. Collection Endpoints (9 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /api/collections | POST | Collection | CreateCollection | Collection | Returns expanded |
| /api/collections | GET | Collection array | GetCollections | [Collection] | All collections |
| /api/collections/:id | GET | Collection | GetCollection | Collection | Single collection |
| /api/collections/:id | PATCH | Collection | UpdateCollection | Collection | Updates metadata |
| /api/collections/:id | DELETE | None | DeleteCollection | EmptyResponse | Removes collection |
| /api/collections/:id/book | POST | Collection | AddBookToCollection | Collection | Adds single book |
| /api/collections/:id/book/:bookId | DELETE | Collection | RemoveBookFromCollection | Collection | Removes book |
| /api/collections/:id/batch/add | POST | Collection | BatchAddBooksToCollection | Collection | Bulk add |
| /api/collections/:id/batch/remove | POST | Collection | BatchRemoveBooksFromCollection | Collection | Bulk remove |

### 8. Playlist Endpoints (10 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /api/playlists | POST | Playlist | CreatePlaylist | Playlist | Returns expanded |
| /api/playlists | GET | Playlist array | GetPlaylists | [Playlist] | User's playlists |
| /api/playlists/:id | GET | Playlist | GetPlaylist | Playlist | Single playlist |
| /api/playlists/:id | PATCH | Playlist | UpdatePlaylist | Playlist | Updates metadata |
| /api/playlists/:id | DELETE | None | DeletePlaylist | EmptyResponse | Removes playlist |
| /api/playlists/:id/item | POST | Playlist | AddItemToPlaylist | Playlist | Adds book/episode |
| /api/playlists/:id/item/:libraryItemId/:episodeId? | DELETE | Playlist | RemoveItemFromPlaylist | Playlist | Removes item |
| /api/playlists/:id/batch/add | POST | Playlist | BatchAddItemsToPlaylist | Playlist | Bulk add |
| /api/playlists/:id/batch/remove | POST | Playlist | BatchRemoveItemsFromPlaylist | Playlist | Bulk remove |
| /api/playlists/collection/:collectionId | POST | Playlist | CreatePlaylistFromCollection | Playlist | From collection |

### 9. Library Endpoints (28 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /api/libraries | POST | Library | CreateLibrary | Library | Requires admin |
| /api/libraries | GET | Library array | GetLibraries | [Library] | `include=stats` |
| /api/libraries/:id | GET | Library | GetLibrary | Library | `include=filterdata` |
| /api/libraries/:id | PATCH | Library | UpdateLibrary | Library | Requires admin |
| /api/libraries/:id | DELETE | Library | DeleteLibrary | Library | Requires admin |
| /api/libraries/:id/items | GET | Paginated LibraryItems | GetLibraryItems | PaginatedLibraryItems | Many filter/sort options |
| /api/libraries/:id/issues | DELETE | None | RemoveLibraryItemsWithIssues | EmptyResponse | Removes invalid items |
| /api/libraries/:id/episode-downloads | GET | Download details | GetLibraryEpisodeDownloads | DownloadQueueDetails | Queue status |
| /api/libraries/:id/series | GET | Paginated Series | GetLibrarySeries | PaginatedSeries | Filter/sort options |
| /api/libraries/:id/series/:seriesId | GET | Series | GetLibrarySeriesById | SeriesBooks | `include=rssfeed,progress` |
| /api/libraries/:id/collections | GET | Paginated Collections | GetLibraryCollections | PaginatedCollections | Filter/sort options |
| /api/libraries/:id/playlists | GET | Paginated Playlists | GetLibraryPlaylists | PaginatedPlaylists | User's playlists |
| /api/libraries/:id/filterdata | GET | FilterData | GetLibraryFilterData | LibraryFilterData | Available filters |
| /api/libraries/:id/personalized | GET | Shelf array | GetPersonalizedShelves | [PersonalizedShelf] | Home screen shelves |
| /api/libraries/:id/search | GET | Match results | SearchLibrary | SearchResults | `q` and `limit` params |
| /api/libraries/:id/stats | GET | Stats object | GetLibraryStats | LibraryStats | Aggregate stats |
| /api/libraries/:id/authors | GET | Author array | GetLibraryAuthors | PaginatedAuthors | Paginated or all |
| /api/libraries/:id/narrators | GET | Narrator array | GetLibraryNarrators | [Narrator] | All narrators |
| /api/libraries/:id/narrators/:narratorId | PATCH | Update count | UpdateNarrator | UpdateResult | Renames narrator |
| /api/libraries/:id/narrators/:narratorId | DELETE | Update count | DeleteNarrator | UpdateResult | Removes narrator |
| /api/libraries/:id/matchall | GET | None (async) | MatchAllLibraryItems | EmptyResponse | Async metadata match |
| /api/libraries/:id/scan | POST | None (async) | ScanLibrary | EmptyResponse | `force` param |
| /api/libraries/:id/recent-episodes | GET | Episode array | GetRecentEpisodes | [PodcastEpisode] | Recent podcast episodes |
| /api/libraries/:id/opml | GET | OPML file | GetLibraryOPML | Data | Export OPML |
| /api/libraries/:id/remove-metadata | POST | Counts | RemoveMetadataFiles | RemoveMetadataResult | `ext=abs\|json` |
| /api/libraries/:id/podcast-titles | GET | Podcast refs | GetPodcastTitles | [PodcastReference] | Title list |
| /api/libraries/:id/download | GET | Binary (zip) | DownloadLibraryItems | Data | `ids` param required |
| /api/libraries/order | POST | Library array | ReorderLibraries | [Library] | Updates display order |

### 10. Session Endpoints (9 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /api/sessions | GET | Paginated sessions | GetAllSessions | PaginatedSessions | Admin endpoint |
| /api/sessions/open | GET | Session arrays | GetOpenSessions | OpenSessions | Active sessions by type |
| /api/session/:id | GET | SessionForClient | GetPlaybackSession | PlaybackSession | Single session |
| /api/session/:id/sync | POST | PlaybackSession | SyncOpenSession | PlaybackSession | Updates progress |
| /api/session/:id/close | POST | PlaybackSession | ClosePlaybackSession | PlaybackSession | Ends session |
| /api/session/:id | DELETE | None | DeletePlaybackSession | EmptyResponse | Removes session |
| /api/sessions/batch/delete | POST | None | BatchDeleteSessions | EmptyResponse | Bulk delete |
| /api/session/local | POST | PlaybackSession | SyncLocalSession | PlaybackSession | Offline sync |
| /api/session/local-all | POST | PlaybackSession array | SyncLocalSessions | [PlaybackSession] | Bulk offline sync |

### 11. Backup Endpoints (7 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /api/backups | GET | Backup array | GetBackups | [Backup] | All backups |
| /api/backups | POST | None (async) | CreateBackup | EmptyResponse | Async creation |
| /api/backups/:id | DELETE | Backup array | DeleteBackup | [Backup] | Returns remaining |
| /api/backups/upload | POST | Status | UploadBackup | BackupUploadStatus | Upload .audiobookshelf |
| /api/backups/path | PATCH | None | UpdateBackupPath | EmptyResponse | Changes backup dir |
| /api/backups/:id/download | GET | Binary file | DownloadBackup | Data | Downloads backup |
| /api/backups/:id/apply | GET | None (async) | ApplyBackup | EmptyResponse | Async restore |

### 12. Notification Endpoints (8 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /api/notifications | GET | NotificationData + Settings | GetNotificationSettings | NotificationSettingsResponse | Combined response |
| /api/notifications | PATCH | None | UpdateNotificationSettings | EmptyResponse | Updates settings |
| /api/notificationdata | GET | NotificationData | GetNotificationData | NotificationData | Available events |
| /api/notifications/test | GET | None | FireTestNotificationEvent | EmptyResponse | `fail` param |
| /api/notifications | POST | NotificationSettings | CreateNotification | Notification | Creates endpoint |
| /api/notifications/:id | DELETE | NotificationSettings | DeleteNotification | NotificationSettings | Removes endpoint |
| /api/notifications/:id | PATCH | NotificationSettings | UpdateNotification | Notification | Updates endpoint |
| /api/notifications/:id/test | GET | Status | SendNotificationTest | EmptyResponse | Tests endpoint |

### 13. Email Endpoints (5 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /api/emails/settings | GET | EmailSettings | GetEmailSettings | EmailSettings | SMTP config |
| /api/emails/settings | PATCH | EmailSettings | UpdateEmailSettings | EmailSettings | Updates SMTP |
| /api/emails/test | POST | None | SendTestEmail | EmptyResponse | Tests SMTP |
| /api/emails/ereader-devices | POST | Device array | UpdateEReaderDevices | [EReaderDevice] | Admin endpoint |
| /api/emails/send-ebook-to-device | POST | None | SendEbookToDevice | EmptyResponse | Sends via email |

### 14. Search Endpoints (6 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /api/search/books | GET | BookSearchResults | SearchBooks | ExternalBookSearchResults | External search |
| /api/search/covers | GET | CoverResults | SearchCovers | ExternalCoverResults | Cover search |
| /api/search/podcasts | GET | PodcastSearchResults | SearchPodcasts | ExternalPodcastSearchResults | iTunes search |
| /api/search/authors | GET | AuthorSearchResults | SearchAuthors | ExternalAuthorSearchResults | External search |
| /api/search/chapters | GET | ChapterData | SearchChapters | ExternalChapterResults | Audible chapters |
| /api/search/providers | GET | Provider lists | GetSearchProviders | SearchProviders | Available providers |

### 15. RSS Feed Endpoints (5 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /api/feeds | GET | Feed arrays | GetRSSFeeds | RSSFeedsResponse | Item + series feeds |
| /api/feeds/item/:itemId/open | POST | Feed | OpenRSSFeedForItem | RSSFeed | Opens item feed |
| /api/feeds/collection/:collectionId/open | POST | Feed | OpenRSSFeedForCollection | RSSFeed | Opens collection feed |
| /api/feeds/series/:seriesId/open | POST | Feed | OpenRSSFeedForSeries | RSSFeed | Opens series feed |
| /api/feeds/:id/close | POST | None | CloseRSSFeed | EmptyResponse | Closes feed |

### 16. Tools/Misc Endpoints (12 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /api/upload | POST | None | UploadFile | EmptyResponse | File upload |
| /api/tasks | GET | Task array | GetTasks | [Task] | `include=queue` |
| /api/watcher/update | POST | None | UpdateWatchedPath | EmptyResponse | Updates watcher |
| /api/validate-cron | POST | Status | ValidateCronExpression | CronValidationResult | Validates cron |
| /api/logger-data | GET | Logger data | GetLoggerData | LoggerData | Log levels |
| /api/filesystem | GET | Filesystem data | GetDirectories | FilesystemResponse | Browse filesystem |
| /api/filesystem/pathexists | POST | Exists boolean | CheckPathExists | PathExistsResponse | Path validation |

### 17. Settings Endpoints (4 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /api/settings | PATCH | ServerSettings | UpdateServerSettings | ServerSettings | Requires admin |
| /api/sorting-prefixes | PATCH | Update result | UpdateSortingPrefixes | UpdateResult | Updates prefixes |
| /api/auth-settings | GET | AuthSettings | GetAuthSettings | AuthSettings | Auth config |
| /api/auth-settings | PATCH | Update result | UpdateAuthSettings | AuthSettings | Updates auth |

### 18. Tags/Genres Endpoints (6 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /api/tags | GET | Tag array | GetAllTags | [String] | All tags |
| /api/tags/rename | POST | Update result | RenameTag | UpdateResult | Renames tag |
| /api/tags/:tag | DELETE | Update result | DeleteTag | UpdateResult | Removes tag |
| /api/genres | GET | Genre array | GetAllGenres | [String] | All genres |
| /api/genres/rename | POST | Update result | RenameGenre | UpdateResult | Renames genre |
| /api/genres/:genre | DELETE | Update result | DeleteGenre | UpdateResult | Removes genre |

### 19. Auth/Server Endpoints (6 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /login | POST | User + token | Login | LoginResponse | JWT auth |
| /logout | POST | None | Logout | EmptyResponse | Ends session |
| /refresh | POST | Refreshed token | RefreshToken | RefreshTokenResponse | Renews JWT |
| /status | GET | Server status | GetServerStatus | ServerStatus | Health check |
| /healthcheck | GET | Health status | Healthcheck | HealthcheckResponse | Simple check |
| /ping | GET | Pong | Ping | PingResponse | Connectivity test |

### 20. Public Endpoints (6 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /public/share/:slug | GET | MediaItemShare | GetMediaItemShareBySlug | MediaItemShare | Public share access |
| /public/share/:slug/track/:index | GET | Binary audio | GetMediaItemShareAudioTrack | Data | Share audio stream |
| /public/share/:slug/cover | GET | Binary image | GetMediaItemShareCover | Data | Share cover image |
| /public/share/:slug/download | GET | Binary file | DownloadMediaItemShare | Data | Download share |
| /public/session/:id/track/:index | GET | Binary audio | GetPublicSessionTrack | Data | Public session audio |

### 21. HLS Endpoints (1 endpoint)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /hls/:stream/:file | GET | Binary HLS | GetHLSSegment | Data | HLS streaming |

### 22. Custom Metadata Provider Endpoints (3 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /api/custom-metadata-providers | GET | Provider array | GetCustomMetadataProviders | [CustomMetadataProvider] | All providers |
| /api/custom-metadata-providers | POST | Provider | CreateCustomMetadataProvider | CustomMetadataProvider | Creates provider |
| /api/custom-metadata-providers/:id | DELETE | None | DeleteCustomMetadataProvider | EmptyResponse | Removes provider |

### 23. Share Endpoints (2 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /api/share/mediaitem | POST | MediaItemShare | CreateMediaItemShare | MediaItemShare | Creates share |
| /api/share/mediaitem/:id | DELETE | None | DeleteMediaItemShare | EmptyResponse | Removes share |

### 24. API Key Endpoints (4 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /api/api-keys | GET | ApiKey array | GetAPIKeys | [APIKey] | All API keys |
| /api/api-keys | POST | ApiKey | CreateAPIKey | APIKey | Creates key |
| /api/api-keys/:id | PATCH | ApiKey | UpdateAPIKey | APIKey | Updates key |
| /api/api-keys/:id | DELETE | None | DeleteAPIKey | EmptyResponse | Removes key |

### 25. Stats Endpoints (2 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /api/stats/server | GET | Stats object | GetServerStats | ServerStats | Server-wide stats |
| /api/stats/year/:year | GET | YearStats | GetAdminYearStats | YearStats | ✅ Implemented 2026-01-28 |

### 26. Cache Endpoints (2 endpoints)

| Endpoint | Method | Response Model | Swift Interface | Swift Response Model | Notes |
|----------|--------|----------------|-----------------|----------------------|-------|
| /api/cache/purge | POST | None | PurgeCacheAll | String | ✅ Implemented 2026-01-28 |
| /api/cache/items/purge | POST | None | PurgeItemsCache | EmptyResponse | Purge items cache |

---

## Server Model Reference

| Server Model | Serialization Methods | Swift Model | Primary Endpoints | Notes |
|--------------|----------------------|-------------|-------------------|-------|
| LibraryItem | toOldJSON, toOldJSONMinified, toOldJSONExpanded | LibraryItem | GET /api/items/:id | Supports expanded tracks |
| Book | toOldJSON, toOldJSONMinified, toOldJSONExpanded | Book | Embedded in LibraryItem | Embedded media type |
| Podcast | toOldJSON, toOldJSONMinified, toOldJSONExpanded | Podcast | Embedded in LibraryItem | Embedded media type |
| PodcastEpisode | toOldJSON, toOldJSONExpanded | PodcastEpisode | GET /api/podcasts/:id/episode/:episodeId | Expanded includes audioTrack |
| User | toOldJSONForBrowser | User | GET /api/users/:id | Special browser format |
| MediaProgress | getOldMediaProgress | MediaProgress | GET /api/me/progress/:id | Progress tracking |
| PlaybackSession | toJSON, toJSONForClient | PlaybackSession | POST /api/items/:id/play | Objects model |
| Author | toOldJSON, toOldJSONExpanded | Author | GET /api/authors/:id | Include params for items/series |
| Series | toOldJSON, toJSONMinimal | SeriesBooks | GET /api/series/:id | Include params for progress |
| Collection | toOldJSON, toOldJSONExpanded | Collection | GET /api/collections/:id | Async expansion |
| Playlist | toOldJSON, toOldJSONExpanded | Playlist | GET /api/playlists/:id | Mixed books/episodes |
| Library | toOldJSON | Library | GET /api/libraries/:id | Library configuration |
| Feed | toOldJSON, toOldJSONMinified | RSSFeed | GET /api/feeds | Minified removes 7 fields |
| FeedEpisode | toJSON | RSSFeedEpisode | Embedded in Feed | RSS episode data |
| MediaItemShare | toJSONForClient | MediaItemShare (Share) | GET /public/share/:slug | Security filtered |
| ApiKey | toJSON | APIKey | GET /api/api-keys | API key management |
| Backup | toJSON | Backup | GET /api/backups | Backup metadata |
| Notification | Custom formats | Notification | GET /api/notifications | Notification config |
| ServerSettings | toJSONForBrowser | ServerSettings | PATCH /api/settings | Browser format |
| CustomMetadataProvider | toClientJson | CustomMetadataProvider | GET /api/custom-metadata-providers | Security filtered |
| AudioFile | toJSON | AudioFile | Embedded in Book/Episode | File metadata |
| AudioTrack | toJSON | AudioTrack | Derived in expanded responses | Playback track |
| AudioMetaTags | Raw object | AudioMetaTags | Embedded in AudioFile | ID3 tags (39 props) |
| BookMetadata | Embedded object | BookMetadata | Embedded in Book | Book-specific metadata |
| PodcastMetadata | Embedded object | PodcastMetadata | Embedded in Podcast | Podcast-specific metadata |
| Chapter | toJSON | BookChapter | Embedded in Book/Episode | Chapter data |
| EbookFile | toJSON | EBookFile | Embedded in Book | Ebook file metadata |
| LibraryFile | toJSON | LibraryFile | Embedded in LibraryItem | Generic file metadata |
| FileMetadata | toJSON | FileMetadata | Embedded in LibraryFile | File stats |
| LibrarySettings | toJSON | LibrarySettings | Embedded in Library | Library config |
| DeviceInfo | Raw object | Device | Embedded in PlaybackSession | Playback device |
| UserPermissions | Raw object | UserPermissions | Embedded in User | Permission flags |
| LibraryFilterData | Custom | LibraryFilterData | GET /api/libraries/:id/filterdata | Available filters |
| Download | toJSONForClient | PodcastEpisodeDownload | GET /api/podcasts/:id/downloads | Episode download |
| Task | toJSON | Task | GET /api/tasks | Background task |
| YearStats | Custom | YearStats | GET /api/me/stats/year/:year | User year stats |
| PodcastFeed | Custom | PodcastFeed | POST /api/podcasts/feed | External RSS feed |
| ExternalSearchResult | Custom | ExternalBookSearchResult, etc. | GET /api/search/* | External API results |


## Socket Event Mapping

### Overview

The server uses WebSocket (Socket.IO) to emit real-time events to connected clients. Events are categorized by emission method and audience.

### Event Emission Methods

| Method | Audience | Description |
|--------|----------|-------------|
| emitter() | All authorized clients | Global broadcast events |
| clientEmitter() | Specific user's clients | User-specific notifications |
| adminEmitter() | Admin users only | Admin-only events |
| libraryItemEmitter() | Users with item access | Library item updates |
| libraryItemsEmitter() | Users with items access | Bulk library item updates |
| socket.emit() | Individual socket | Direct responses |

### Global Broadcast Events (30 events)

Events emitted to all authorized clients:

| Swift Event | Event Name | Response Model | Category |
|-------------|------------|----------------|----------|
| AdminMessage | admin_message | String | Messaging |
| AuthorAdded | author_added | Author | Authors |
| AuthorRemoved | author_removed | String (ID) | Authors |
| AuthorUpdated | author_updated | Author | Authors |
| BackupApplied | backup_applied | None | Backups |
| CollectionAdded | collection_added | Collection | Collections |
| CollectionRemoved | collection_removed | String (ID) | Collections |
| CollectionUpdated | collection_updated | Collection | Collections |
| CustomMetadataProviderAdded | custom_metadata_provider_added | CustomMetadataProvider | Providers |
| CustomMetadataProviderRemoved | custom_metadata_provider_removed | String (ID) | Providers |
| EpisodeAdded | episode_added | PodcastEpisode | Podcasts |
| EpisodeDownloadFinished | episode_download_finished | PodcastEpisodeDownload | Podcasts |
| EpisodeDownloadQueueCleared | episode_download_queue_cleared | String (Library ID) | Podcasts |
| EpisodeDownloadQueued | episode_download_queued | PodcastEpisodeDownload | Podcasts |
| EpisodeDownloadStarted | episode_download_started | PodcastEpisodeDownload | Podcasts |
| ItemRemoved | item_removed | String (ID) | Library Items |
| LibraryAdded | library_added | Library | Libraries |
| LibraryRemoved | library_removed | String (ID) | Libraries |
| LibraryUpdated | library_updated | Library | Libraries |
| MetadataEmbedQueueUpdate | metadata_embed_queue_update | Custom | Metadata |
| NotificationsUpdated | notifications_updated | NotificationSettings | Notifications |
| RSSFeedClosed | rss_feed_closed | String (ID) | RSS Feeds |
| RSSFeedOpened | rss_feed_open | RSSFeed | RSS Feeds |
| SeriesAdded | series_added | Series | Series |
| SeriesRemoved | series_removed | String (ID) | Series |
| SeriesUpdated | series_updated | Series | Series |
| StreamReset | stream_reset | String (ID) | Streaming |
| TaskFinished | task_finished | Task | Tasks |
| TaskStarted | task_started | Task | Tasks |

### User-Specific Events (8 events)

Events emitted to specific user's clients:

| Swift Event | Event Name | Response Model | Category |
|-------------|------------|----------------|----------|
| BatchQuickMatchComplete | batch_quickmatch_complete | Custom | Matching |
| EReaderDevicesUpdated | ereader-devices-updated | [EReaderDevice] | E-Readers |
| PlaylistAdded | playlist_added | Playlist | Playlists |
| PlaylistRemoved | playlist_removed | String (ID) | Playlists |
| PlaylistUpdated | playlist_updated | Playlist | Playlists |
| UserItemProgressUpdated | user_item_progress_updated | MediaProgress | Progress |
| UserSessionClosed | user_session_closed | PlaybackSession | Sessions |
| UserUpdated | user_updated | User | Users |

### Admin-Only Events (13 events)

Events emitted only to admin users:

| Swift Event | Event Name | Response Model | Category |
|-------------|------------|----------------|----------|
| EReaderDevicesUpdated | ereader-devices-updated | [EReaderDevice] | E-Readers |
| MetadataEmbedQueueUpdate | metadata_embed_queue_update | Custom | Metadata |
| ShareClosed | share_closed | String (ID) | Shares |
| ShareOpened | share_open | MediaItemShare | Shares |
| TaskProgress | task_progress | Custom | Tasks |
| TrackFinishedEvent | track_finished | Custom | Audio Processing |
| TrackProgressEvent | track_progress | Custom | Audio Processing |
| TrackStartedEvent | track_started | Custom | Audio Processing |
| UserAdded | user_added | User | Users |
| UserOffline | user_offline | User | Users |
| UserOnline | user_online | User | Users |
| UserRemoved | user_removed | String (ID) | Users |
| UserStreamUpdate | user_stream_update | Custom | Streaming |

### Library Item Access Events (4 events)

Events emitted to users with library item access:

| Swift Event | Event Name | Response Model | Category |
|-------------|------------|----------------|----------|
| ItemAdded | item_added | LibraryItem (expanded) | Library Items |
| ItemUpdated | item_updated | LibraryItem (expanded) | Library Items |
| ItemsAdded | items_added | [LibraryItem] (expanded) | Library Items |
| ItemsUpdated | items_updated | [LibraryItem] (expanded) | Library Items |

### Direct Socket Events (9 events)

Events emitted directly to individual sockets:

| Swift Event | Event Name | Response Model | Category |
|-------------|------------|----------------|----------|
| AuthFailed | auth_failed | Custom | Authentication |
| CoverSearchCancelled | cover_search_cancelled | Custom | Cover Search |
| CoverSearchComplete | cover_search_complete | Custom | Cover Search |
| CoverSearchError | cover_search_error | Custom | Cover Search |
| CoverSearchProviderError | cover_search_provider_error | Custom | Cover Search |
| CoverSearchResult | cover_search_result | Custom | Cover Search |
| InitEvent | init | Custom | Connection |
| LogEvent | log | LogEventObject | Logging |
| PongEvent | pong | None | Keepalive |

### Client-to-Server Events (6 events)

Events sent from clients TO the server (not emitted BY server):

| Swift Event | Event Name | Purpose |
|-------------|------------|---------|
| AuthEvent | auth | Authenticate socket connection |
| CancelScanEvent | cancel_scan | Cancel library scan operation |
| FetchDailyLogsEvent | fetch_daily_logs | Request daily log data |
| PingEvent | ping | Send keepalive ping |
| RemoveLogListenerEvent | remove_log_listener | Stop streaming logs |
| SetLogListenerEvent | set_log_listener | Start streaming logs |

### Socket Event Files

Events are organized by category in the Swift package:

| File | Events | Categories |
|------|--------|-----------|
| AudioMetadataEvents.swift | 7 | Audio processing, track processing |
| AuthorEvents.swift | 3 | Author CRUD operations |
| BackupEvents.swift | 1 | Backup operations |
| ClientEvents.swift | 6 | Client-to-server requests |
| CollectionEvents.swift | 3 | Collection CRUD operations |
| CoverSearchEvents.swift | 6 | Cover search operations |
| CustomMetadataProviderEvents.swift | 2 | Custom provider CRUD |
| EReaderEvents.swift | 1 | E-reader device management |
| LibraryEvents.swift | 3 | Library CRUD operations |
| LibraryItemEvents.swift | 5 | Library item CRUD operations |
| LibraryScanEvents.swift | 4 | Library scanning operations |
| MiscellaneousEvents.swift | 8 | Logs, admin messages, metadata embed |
| NotificationEvents.swift | 1 | Notification settings |
| PlaylistEvents.swift | 3 | Playlist CRUD operations |
| PodcastEpisodeDownloadEvents.swift | 5 | Episode download operations |
| RSSFeedEvents.swift | 2 | RSS feed operations |
| SeriesEvents.swift | 4 | Series CRUD operations |
| ShareEvents.swift | 2 | Media share operations |
| StreamEvents.swift | 7 | Streaming operations |
| TaskEvents.swift | 3 | Background task operations |
| UserEvents.swift | 10 | User management operations |
