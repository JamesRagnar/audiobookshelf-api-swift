import AudiobookshelfAPI
import Foundation
import Testing

private typealias Fixtures = MaintainedContractFixtures

@Suite
struct LegacyContractCompatibilityTests {

    // Deprecated tests deliberately exercise retained deprecated entry points.
    @available(*, deprecated)
    @Test
    func partialNotificationWritesRetainIgnoredFieldsAndOmission() throws {
        let json = try Fixtures.encoded(UpdateNotificationSettings.Request(
            appriseApiUrl: "url", maxFailedAttempts: 7, notificationDelay: 1000
        ).body)
        #expect(json["appriseApiUrl"] as? String == "url")
        #expect(json["maxFailedAttempts"] as? Int == 7)
        #expect(json["notificationDelay"] as? Int == 1000)
        #expect(json["maxNotificationQueue"] == nil)
    }

    @available(*, deprecated)
    @Test
    func legacyUserLockedFlagStillEncodes() throws {
        let json = try Fixtures.encoded(UpdateUser.Request(userId: "user-1", isLocked: false).body)
        #expect(json["isLocked"] as? Bool == false)
    }

    @available(*, deprecated)
    @Test
    func podcastAndLoggerAliasesPreserveHonestConversions() throws {
        let podcast = try Fixtures.decode(ExternalPodcastSearchResult.self, Fixtures.podcastSearch)
        #expect(podcast.itunesId == "123")
        #expect(podcast.author == nil)
        #expect(podcast.artwork == nil)
        #expect(podcast.itunesPageUrl == "https://example.invalid/p")
        let logger = try Fixtures.decode(GetLoggerData.Response.self, "{\"currentDailyLogs\":[]}")
        #expect(logger.logs.isEmpty)
    }

    @available(*, deprecated)
    @Test
    func rawUploadAndCoverFeedInitializersRetainTheirWireEncoding() throws {
        let bytes = Data("complete multipart".utf8)
        let cover = UploadLibraryItemCover.Request(
            itemId: "item-1", imageData: bytes, contentType: "multipart/form-data; boundary=legacy"
        )
        let backup = UploadBackup.Request(backupFile: bytes, mimeType: "multipart/form-data; boundary=legacy")
        #expect(cover.body.data == bytes)
        #expect(backup.body.data == bytes)
        let local = UpdateLibraryItemCover.Request(itemId: "item-1", url: "url", cover: "/cover.jpg")
        #expect(try Fixtures.encoded(local.body) as? [String: String] == ["url": "url", "cover": "/cover.jpg"])
        let feed = GetPodcastFeed.Request(rssFeed: "rss", libraryId: "library-1", folderId: "folder-1")
        let json = try Fixtures.encoded(feed.body)
        #expect(json["libraryId"] as? String == "library-1")
        #expect(json["folderId"] as? String == "folder-1")
    }

}
