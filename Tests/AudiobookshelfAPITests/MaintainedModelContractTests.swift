import AudiobookshelfAPI
import Foundation
import Testing

private typealias Fixtures = MaintainedContractFixtures

@Suite
struct MaintainedModelContractTests {

    @Test
    func apiKeysDecodeThroughAllEnclosingEndpoints() throws {
        let created = try Fixtures.response(
            CreateAPIKey.self, "{\"apiKey\":\(try Fixtures.changed(Fixtures.apiKey, key: "apiKey", value: "secret"))}"
        )
        let listed = try Fixtures.response(GetAllAPIKeys.self, "{\"apiKeys\":[\(Fixtures.apiKey)]}")
        let updated = try Fixtures.response(UpdateAPIKey.self, "{\"apiKey\":\(Fixtures.apiKey)}")
        #expect(created.apiKey.apiKey == "secret")
        #expect(created.apiKey.details.createdAt.timeIntervalSince1970 == 1_767_225_600)
        #expect(updated.apiKey.updatedAt.timeIntervalSince1970 == 1_767_312_000.125)
        #expect(listed.apiKeys.first?.permissions == nil)
        #expect(updated.apiKey.createdByUserId == nil)
        #expect(updated.apiKey.user?.username == "reader")
        #expect(updated.apiKey.user?.type == .user)
    }

    @Test(arguments: ["createdAt", "updatedAt", "expiresAt", "lastUsedAt"], ["123", "\"bad\"", "true", "{}"])
    func apiKeyDatesRejectWrongTypesAndMalformedStrings(key: String, raw: String) throws {
        var row = try Fixtures.object(Fixtures.apiKey)
        row[key] = try JSONSerialization.jsonObject(with: Data(raw.utf8), options: [.fragmentsAllowed])
        let json = try Fixtures.json(row)
        #expect(throws: (any Error).self) {
            try Fixtures.response(UpdateAPIKey.self, "{\"apiKey\":\(json)}")
        }
    }

    @Test(arguments: ["permissions", "user", "createdByUser", "isActive", "description"])
    func apiKeyRejectsUnrelatedNonNullTypes(key: String) throws {
        let json = try Fixtures.changed(Fixtures.apiKey, key: key, value: 123)
        #expect(throws: DecodingError.self) { try Fixtures.decode(APIKey.self, json) }
    }

    @Test(arguments: ["createdAt", "updatedAt", "expiresAt"])
    func shareDatesRejectNumericAndMalformedNonNullValues(key: String) throws {
        let numeric = try Fixtures.changed(Fixtures.share, key: key, value: 1000)
        let malformed = try Fixtures.changed(Fixtures.share, key: key, value: "not-a-date")
        #expect(throws: DecodingError.self) { try Fixtures.decode(Share.self, numeric) }
        #expect(throws: (any Error).self) {
            try Fixtures.response(CreateMediaItemShare.self, malformed, status: 201)
        }
        #expect(throws: DecodingError.self) { try Fixtures.decode(ShareClosedEvent.Schema.self, numeric) }
    }

    @Test(arguments: ["createdAt", "updatedAt", "id", "name", "userId", "isActive"])
    func apiKeyRequiredFieldsRejectMissingAndNull(key: String) throws {
        let missing = try Fixtures.changed(Fixtures.apiKey, key: key, value: nil)
        let null = try Fixtures.changed(Fixtures.apiKey, key: key, value: NSNull())
        #expect(throws: DecodingError.self) { try Fixtures.decode(APIKey.self, missing) }
        #expect(throws: DecodingError.self) { try Fixtures.decode(APIKey.self, null) }
    }

    @Test(arguments: ["{}", "{\"explicit\":null}", "{\"explicit\":false}", "{\"explicit\":true}"])
    func audibleExplicitRetainsUnknownVersusFalse(json: String) throws {
        var object = try Fixtures.object(json)
        object["title"] = "Book"
        object["duration"] = 91.5
        let result = try Fixtures.decode(ExternalBookSearchResult.self, Fixtures.json(object))
        #expect(result.duration == 91.5)
        #expect(result.explicit == (object["explicit"] as? Bool))
    }

    @Test(arguments: ["duration", "publishedYear", "tags"], ["true", "{}", "[1]"])
    func bookSearchRejectsUnsupportedTypes(key: String, raw: String) {
        #expect(throws: DecodingError.self) {
            try Fixtures.decode(ExternalBookSearchResult.self, "{\"title\":\"Book\",\"\(key)\":\(raw)}")
        }
    }

    @Test
    func podcastsUseNumericCanonicalSearchKeys() throws {
        let result = try Fixtures.response(SearchExternalPodcasts.self, "[\(Fixtures.podcastSearch)]")
        #expect(result.first?.id == 123)
        #expect(result.first?.artistId == nil)
        #expect(result.first?.artistName == nil)
        #expect(result.first?.cover == nil)
        #expect(result.first?.descriptionPlain.isEmpty == true)
        #expect(result.first?.genres == [])
        #expect(result.first?.explicit == false)
        let stringID = try Fixtures.changed(Fixtures.podcastSearch, key: "id", value: "123")
        #expect(throws: DecodingError.self) { try Fixtures.decode(ExternalPodcastSearchResult.self, stringID) }
    }

    @Test(arguments: ["id", "artistId"])
    func podcastSearchRejectsStringIdentifiers(key: String) throws {
        let json = try Fixtures.changed(Fixtures.podcastSearch, key: key, value: "123")
        #expect(throws: DecodingError.self) { try Fixtures.decode(ExternalPodcastSearchResult.self, json) }
    }

    @Test(arguments: ["timestamp", "source", "levelName", "level", "message"])
    func logEntriesRequireRealFields(key: String) throws {
        let row = """
        {"timestamp":"now","source":"server","levelName":"INFO","level":2,"message":"message"}
        """
        let missing = try Fixtures.changed(row, key: key, value: nil)
        #expect(throws: DecodingError.self) { try Fixtures.decode(LogEventObject.self, missing) }
    }

    @Test(arguments: ["id", "action", "title", "startedAt", "data"])
    func backgroundTasksRejectMissingRequiredFields(key: String) throws {
        let json = try Fixtures.changed(Fixtures.task, key: key, value: nil)
        #expect(throws: DecodingError.self) { try Fixtures.decode(BackgroundTask.self, json) }
    }

    @Test(arguments: [0, 11])
    func userYearRetainsCountsSecondsAndZeroBasedMonth(month: Int) throws {
        let json = try Fixtures.changed(Fixtures.userYear, key: "mostListenedMonth",
                                        value: ["month": month, "time": 90])
        let result = try Fixtures.response(GetYearStats.self, json)
        #expect(result.mostListenedMonth?.month == month)
        #expect(result.totalListeningTime == 90)
        #expect(result.totalBookListeningTime == 60)
        #expect(result.totalPodcastListeningTime == 30)
        #expect(result.topAuthors.first?.time == 60)
        #expect(result.topGenres.first?.time == 60)
        #expect(result.numBooksFinished == 1)
        #expect(result.booksWithCovers == ["item-1"])
        #expect(result.longestAudiobookFinished?.finishedAt.timeIntervalSince1970 == 1_767_225_600.125)
    }

    @Test
    func yearEndpointsHaveDistinctEmptyAndPopulatedShapes() throws {
        let emptyUser = try Fixtures.response(GetYearStats.self, Fixtures.emptyUserYear)
        let emptyAdmin = try Fixtures.response(GetAdminYearStats.self, Fixtures.emptyAdminYear)
        let admin = try Fixtures.response(GetAdminYearStats.self, Fixtures.adminYear)
        #expect(emptyUser.totalListeningSessions == 0)
        #expect(emptyUser.mostListenedMonth == nil)
        #expect(emptyUser.booksWithCovers.isEmpty)
        #expect(emptyAdmin.topAuthors.isEmpty)
        #expect(admin.totalBooksDuration == 360.25)
        #expect(admin.totalListeningTime == 90.5)
        #expect(admin.booksAddedWithCovers == ["item-1"])
    }

    @Test(arguments: ["totalListeningSessions", "booksWithCovers", "numBooksFinished"])
    func userYearRejectsMissingRealFields(key: String) throws {
        let json = try Fixtures.changed(Fixtures.userYear, key: key, value: nil)
        #expect(throws: DecodingError.self) { try Fixtures.decode(YearStats.self, json) }
    }

    @Test(arguments: ["numListeningSessions", "totalBooksDuration", "booksAddedWithCovers"])
    func adminYearRejectsMissingRealFields(key: String) throws {
        let json = try Fixtures.changed(Fixtures.adminYear, key: key, value: nil)
        #expect(throws: DecodingError.self) { try Fixtures.decode(AdminYearStats.self, json) }
    }

    @Test
    func tasksRetainNestedJSONThroughRESTAndSockets() throws {
        let rest = try Fixtures.response(GetTasks.self, "{\"tasks\":[\(Fixtures.task)]}")
        let started = try Fixtures.decode(TaskStarted.Schema.self, Fixtures.task)
        let finished = try Fixtures.decode(TaskFinished.Schema.self, Fixtures.task)
        #expect(rest.tasks.first?.description == nil)
        #expect(started.titleKey == nil)
        #expect(finished.finishedAt == 2000)
        guard case .object(let options) = started.data["options"],
              case .bool(true) = options["enabled"],
              case .null = options["nullable"],
              case .number(1.25) = started.data["duration"] else {
            Issue.record("Nested task data was not retained")
            return
        }
        let empty = try Fixtures.changed(Fixtures.task, key: "data", value: [:] as [String: String])
        #expect(try Fixtures.decode(BackgroundTask.self, empty).data.isEmpty)
    }

    @Test(arguments: Array(0...6))
    func loggerUsesIdenticalRESTAndSocketLevels(level: Int) throws {
        let names = ["TRACE", "DEBUG", "INFO", "WARN", "ERROR", "FATAL", "NOTE"]
        let json = "{\"timestamp\":\"12:30:00\",\"message\":\"msg\",\"levelName\":\"\(names[level])\","
            + "\"level\":\(level),\"source\":\"Scanner\"}"
        let rest = try Fixtures.response(GetLoggerData.self, "{\"currentDailyLogs\":[\(json)]}")
        let socket = try Fixtures.decode(LogEvent.Schema.self, json)
        #expect(rest.currentDailyLogs.first?.timestamp == "12:30:00")
        #expect(socket.level.rawValue == level)
        #expect(socket.levelName.rawValue == names[level])
        #expect(socket.source == "Scanner")
    }

    @Test(arguments: ["[]", "\"\""])
    func loggerNormalizesOnlyTheEmptyFallback(raw: String) throws {
        let result = try Fixtures.response(GetLoggerData.self, "{\"currentDailyLogs\":\(raw)}")
        #expect(result.currentDailyLogs.isEmpty)
    }

    @Test(arguments: ["null", "{}", "1", "true", "\"not empty\""])
    func loggerRejectsWrongContainers(raw: String) {
        #expect(throws: (any Error).self) {
            try Fixtures.response(GetLoggerData.self, "{\"currentDailyLogs\":\(raw)}")
        }
    }

    @Test(arguments: ["\"UNKNOWN\"", "\"TRACE\""])
    func loggerRejectsUnknownOrInvalidLevelPairs(name: String) {
        #expect(throws: DecodingError.self) {
            try Fixtures.decode(LogEventObject.self,
                                "{\"timestamp\":\"now\",\"message\":\"msg\",\"source\":\"s\","
                                    + "\"levelName\":\(name),\"level\":99}")
        }
    }

    @Test
    func sharesAndAnonymousSessionsDecodeThroughEnclosingEndpoints() throws {
        let lookup = try Fixtures.response(
            GetMediaShare.self,
            try Fixtures.changed(Fixtures.share, key: "playbackSession", value: Fixtures.object(Fixtures.session))
        )
        let open = try Fixtures.response(
            GetOpenSessions.self, "{\"sessions\":[],\"shareSessions\":[\(Fixtures.session)]}"
        )
        let history = try Fixtures.response(
            GetAllSessions.self,
            "{\"total\":1,\"numPages\":1,\"page\":0,\"itemsPerPage\":10,\"sessions\":[\(Fixtures.session)]}"
        )
        let created = try Fixtures.response(CreateMediaItemShare.self, Fixtures.share, status: 201)
        let opened = try Fixtures.decode(ShareOpenEvent.Schema.self, Fixtures.share)
        let closed = try Fixtures.decode(ShareClosedEvent.Schema.self, Fixtures.share)
        #expect(lookup.playbackSession.userId == nil)
        #expect(lookup.playbackSession.deviceInfo?.userId == nil)
        #expect(open.shareSessions.first?.userId == nil)
        #expect(history.sessions.first?.userId == nil)
        #expect(lookup.playbackSession.coverAspectRatio == nil)
        #expect(created.expiresAt == nil)
        #expect(opened.createdAt.timeIntervalSince1970 == 1_767_225_600)
        #expect(closed.updatedAt.timeIntervalSince1970 == 1_767_312_000.125)
    }

    @Test
    func playbackMetadataPreservesPodcastAuthorAndFeed() throws {
        var row = try Fixtures.object(Fixtures.session)
        row["mediaType"] = "podcast"
        row["mediaMetadata"] = ["title": "Podcast", "genres": [], "author": "Creator",
                                "feedUrl": "https://example.invalid/feed"] as [String: Any]
        let podcast = try Fixtures.decode(PlaybackSession.self, Fixtures.json(row))
        guard case .podcast(let metadata) = podcast.mediaMetadata else {
            Issue.record("Podcast metadata selected as a book")
            return
        }
        #expect(metadata.author == "Creator")
        #expect(metadata.feedUrl == "https://example.invalid/feed")
        #expect(podcast.coverAspectRatio == nil)
        let shareJSON = try Fixtures.changed(
            try Fixtures.changed(Fixtures.session, key: "serverVersion", value: "2.33.2"),
            key: "coverAspectRatio", value: 1
        )
        let book = try Fixtures.decode(PlaybackSession.self, shareJSON)
        #expect(book.coverAspectRatio == 1)
        guard case .book(let bookMetadata) = book.mediaMetadata else {
            Issue.record("Book discriminator was ignored")
            return
        }
        #expect(bookMetadata.title == "Book")
    }

    @Test
    func libraryFiltersRetainCountsIndependentOfArrayLengths() throws {
        let book = try Fixtures.response(GetLibraryFilterData.self, Fixtures.filters)
        let include = try Fixtures.decode(FilterData.self, Fixtures.filters)
        let podcastJSON = try Fixtures.changed(
            try Fixtures.changed(Fixtures.filters, key: "bookCount", value: 0), key: "podcastCount", value: 3
        )
        let podcast = try Fixtures.response(GetLibraryFilterData.self, podcastJSON)
        #expect(book.authors.isEmpty)
        #expect(book.bookCount == 7)
        #expect(include.bookCount == 7)
        #expect(include.loadedAt == 1000)
        #expect(podcast.podcastCount == 3)
        let missing = try Fixtures.changed(Fixtures.filters, key: "publishers", value: nil)
        #expect(throws: DecodingError.self) { try Fixtures.decode(LibraryFilterData.self, missing) }
    }

}
