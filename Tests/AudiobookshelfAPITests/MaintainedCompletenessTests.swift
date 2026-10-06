import AudiobookshelfAPI
import Foundation
import Testing

private typealias Fixtures = MaintainedContractFixtures

@Suite
struct MaintainedCompletenessTests {

    @Test
    func latestSessionAndPersistedPermissionsDecodeAllVariants() throws {
        let absent = try Fixtures.response(GetAllUsers.self, "{\"users\":[\(Fixtures.user)]}")
        let nullJSON = try Fixtures.changed(Fixtures.user, key: "latestSession", value: NSNull())
        let null = try Fixtures.response(GetAllUsers.self, "{\"users\":[\(nullJSON)]}")
        let populatedJSON = try Fixtures.changed(
            Fixtures.user, key: "latestSession", value: Fixtures.object(Fixtures.session)
        )
        let populated = try Fixtures.response(GetAllUsers.self, "{\"users\":[\(populatedJSON)]}")
        #expect(absent.users.first?.latestSession == nil)
        #expect(null.users.first?.latestSession == nil)
        #expect(populated.users.first?.latestSession?.id == "session-1")
        #expect(absent.users.first?.permissions.createEreader == nil)
        let permissions = try Fixtures.decode(UserPermissions.self, """
        {"download":true,"update":false,"delete":false,"upload":false,"accessAllLibraries":false,
         "accessAllTags":false,"accessExplicitContent":true,"createEreader":true,
         "selectedTagsNotAccessible":true}
        """)
        #expect(permissions.createEreader == true)
        #expect(permissions.selectedTagsNotAccessible == true)
        #expect(GetAllUsers.Request().queryItems == nil)
        #expect(GetAllUsers.Request(includeLatestSession: true).queryItems?["include"] == "latestSession")
    }

    @Test
    func enrichedProgressUsesISODatesWithoutChangingIntegerUnits() throws {
        let json = """
        {"id":"progress-1","userId":"user-1","libraryItemId":"item-1","mediaItemId":"book-1",
         "mediaItemType":"book","duration":120,"progress":0.5,"currentTime":60,"isFinished":false,
         "hideFromContinueListening":false,"lastUpdate":2000,"startedAt":1000,"finishedAt":null,
         "displayTitle":"Book","displaySubtitle":"Author","coverPath":"/cover.jpg",
         "mediaUpdatedAt":"2026-01-01T00:00:00.125Z"}
        """
        let progress = try Fixtures.decode(MediaProgress.self, json)
        #expect(progress.lastUpdate == 2000)
        #expect(progress.startedAt == 1000)
        #expect(progress.mediaUpdatedAt?.timeIntervalSince1970 == 1_767_225_600.125)
        #expect(progress.displayTitle == "Book")
        #expect(progress.displaySubtitle == "Author")
        #expect(progress.coverPath == "/cover.jpg")
        let invalid = try Fixtures.changed(json, key: "mediaUpdatedAt", value: 1000)
        #expect(throws: DecodingError.self) { try Fixtures.decode(MediaProgress.self, invalid) }
        let null = try Fixtures.changed(json, key: "mediaUpdatedAt", value: NSNull())
        #expect(try Fixtures.decode(MediaProgress.self, null).mediaUpdatedAt == nil)
    }

    @Test
    func metadataAndLibraryItemEnrichmentsDecodeWithoutInventedDefaults() throws {
        let metadata = try Fixtures.decode(BookMetadata.self,
                                           "{\"title\":\"Book\",\"genres\":[],\"descriptionPlain\":\"Text\"}")
        #expect(metadata.descriptionPlain == "Text")
        let absent = try Fixtures.decode(LibraryItem.self, TestFixtures.podcastLibraryItemJSON)
        #expect(absent.numEpisodesIncomplete == nil)
        let enrichedJSON = try Fixtures.changed(
            try Fixtures.changed(TestFixtures.bookLibraryItemJSON, key: "numEpisodesIncomplete", value: 3),
            key: "mediaItemShare", value: Fixtures.object(Fixtures.share)
        )
        let enriched = try Fixtures.decode(LibraryItem.self, enrichedJSON)
        #expect(enriched.numEpisodesIncomplete == 3)
        #expect(enriched.mediaItemShare?.createdAt.timeIntervalSince1970 == 1_767_225_600)
    }

    @Test
    func shareIncludesRetainCommaSeparatedSerialization() {
        let detail = GetLibraryItem.Request(itemID: "item-1", expanded: true, include: [.share, .progress])
        #expect(Set((detail.queryItems?["include"] ?? "").split(separator: ",")) == ["share", "progress"])
        let list = GetLibraryItems.Request(libraryID: "library-1", include: [.share, .rssfeed])
        #expect(Set((list.queryItems?["include"] ?? "").split(separator: ",")) == ["share", "rssfeed"])
        let shelf = GetPersonalizedLibrary.Request(libraryID: "library-1", include: [.share])
        #expect(shelf.queryItems?["include"] == "share")
    }

    @Test(arguments: [false, true])
    func seriesMutationsDecodeChangedAndNoOpUserResponses(hidden: Bool) throws {
        let json = try Fixtures.changed(
            Fixtures.user, key: "seriesHideFromContinueListening", value: hidden ? ["series-1"] : []
        )
        let removed = try Fixtures.response(RemoveSeriesFromContinueListening.self, json)
        let readded = try Fixtures.response(ReaddSeriesToContinueListening.self, json)
        #expect(removed.id == "user-1")
        #expect(readded.seriesHideFromContinueListening == (hidden ? ["series-1"] : []))
        #expect(RemoveSeriesFromContinueListening.Request(seriesId: "series-1").method == .get)
        #expect(ReaddSeriesToContinueListening.Request(seriesId: "series-1").method == .get)
    }

    @Test
    func localISODecodingPreservesCallerConfiguration() throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let date = try decoder.decode(Share.self, from: Fixtures.data(Fixtures.share))
        #expect(date.createdAt.timeIntervalSince1970 == 1_767_225_600)
        struct Unrelated: Decodable { let timestamp: Date }
        let unrelated = try decoder.decode(Unrelated.self, from: Data("{\"timestamp\":1000}".utf8))
        #expect(unrelated.timestamp.timeIntervalSince1970 == 1000)
    }

}
