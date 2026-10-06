import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

/// Shared fixtures for the maintained REST and socket contracts.
enum MaintainedContractFixtures {

    static let apiKey = """
    {"id":"key-1","name":"Reader","userId":"user-1","isActive":true,"description":null,
     "permissions":null,"createdByUserId":null,"expiresAt":null,"lastUsedAt":null,
     "createdAt":"2026-01-01T00:00:00Z","updatedAt":"2026-01-02T00:00:00.125Z",
     "user":{"id":"user-1","username":"reader","type":"user","largerOwnerField":true},
     "createdByUser":null}
    """

    static let user = """
    {"id":"user-1","username":"reader","type":"user","isActive":true,"isLocked":false,
     "createdAt":1000,"seriesHideFromContinueListening":[],
     "permissions":{"download":true,"update":false,"delete":false,"upload":false,
      "accessAllLibraries":true,"accessAllTags":false,"accessExplicitContent":true},
     "librariesAccessible":[],"itemTagsSelected":[]}
    """

    static let session = """
    {"id":"session-1","userId":null,"libraryItemId":"item-1","mediaType":"book",
     "mediaMetadata":{"title":"Book","genres":[]},"displayTitle":"Book","displayAuthor":"Author",
     "duration":120.5,"playMethod":0,"serverVersion":"2.26.0","date":"2026-01-01",
     "dayOfWeek":"Thursday","startTime":0,"currentTime":1.5,"startedAt":1000,"updatedAt":2000,
     "deviceInfo":{"id":"device-1","deviceId":"browser-1","clientName":"Browser"}}
    """

    static let share = """
    {"id":"share-1","slug":"book","mediaItemType":"book","mediaItemId":"book-1",
     "isDownloadable":false,"expiresAt":null,"createdAt":"2026-01-01T00:00:00Z",
     "updatedAt":"2026-01-02T00:00:00.125Z"}
    """

    static let rssEpisode = """
    {"title":"Episode","subtitle":"","description":"","descriptionPlain":"","pubDate":"",
     "episodeType":"","season":"","episode":"","author":"","duration":"1.25","explicit":"",
     "publishedAt":null,"durationSeconds":1.25,"guid":null,
     "enclosure":{"url":"https://example.invalid/episode.mp3","type":null,"length":null},
     "chaptersUrl":"https://example.invalid/chapters.json","chaptersType":"application/json",
     "chapters":[{"id":0,"start":0.25,"end":1.25,"title":"Intro"}]}
    """

    static let podcastSearch = """
    {"title":"Podcast","id":123,"artistId":null,"artistName":null,"description":"",
     "descriptionPlain":"","releaseDate":"2026-01-01T00:00:00Z","genres":[],"cover":null,
     "trackCount":4,"feedUrl":"https://example.invalid/feed","pageUrl":"https://example.invalid/p",
     "explicit":false}
    """

    static let userYear = """
    {"totalListeningSessions":2,"totalListeningTime":90,"totalBookListeningTime":60,
     "totalPodcastListeningTime":30,"numBooksFinished":1,"numBooksListened":2,
     "topAuthors":[{"name":"Author","time":60}],"topGenres":[{"genre":"Fiction","time":60}],
     "mostListenedNarrator":{"name":"Narrator","time":60},
     "mostListenedMonth":{"month":0,"time":90},
     "longestAudiobookFinished":{"id":"book-1","title":"Book","duration":120,
      "finishedAt":"2026-01-01T00:00:00.125Z"},
     "booksWithCovers":["item-1"],"finishedBooksWithCovers":["item-1"]}
    """

    static let emptyUserYear = """
    {"totalListeningSessions":0,"totalListeningTime":0,"totalBookListeningTime":0,
     "totalPodcastListeningTime":0,"numBooksFinished":0,"numBooksListened":0,
     "topAuthors":[],"topGenres":[],"mostListenedNarrator":null,"mostListenedMonth":null,
     "longestAudiobookFinished":null,"booksWithCovers":[],"finishedBooksWithCovers":[]}
    """

    static let adminYear = """
    {"numListeningSessions":2,"numBooksAdded":1,"numAuthorsAdded":1,"numBooks":3,
     "totalBooksAddedSize":100,"totalBooksSize":300,"totalBooksAddedDuration":120,
     "totalBooksDuration":360.25,"totalListeningTime":90.5,"booksAddedWithCovers":["item-1"],
     "topAuthors":[{"name":"Author","time":60}],"topNarrators":[{"name":"Narrator","time":60}],
     "topGenres":[{"genre":"Fiction","time":60}]}
    """

    static let emptyAdminYear = """
    {"numListeningSessions":0,"numBooksAdded":0,"numAuthorsAdded":0,"numBooks":0,
     "totalBooksAddedSize":0,"totalBooksSize":0,"totalBooksAddedDuration":0,
     "totalBooksDuration":0,"totalListeningTime":0,"booksAddedWithCovers":[],
     "topAuthors":[],"topNarrators":[],"topGenres":[]}
    """

    static let task = """
    {"id":"task-1","action":"encode","title":"Encoding","titleKey":null,"titleSubs":null,
     "description":null,"descriptionKey":null,"descriptionSubs":null,
     "data":{"duration":1.25,"originalTrackPaths":["a"],"options":{"enabled":true,"nullable":null},
             "chapters":[{"start":0.25}]},"showSuccess":true,"isFailed":false,
     "isFinished":true,"startedAt":1000,"finishedAt":2000}
    """

    static let filters = """
    {"authors":[],"genres":[],"tags":[],"series":[],"narrators":[],"languages":[],
     "publishers":[],"publishedDecades":[],"bookCount":7,"authorCount":0,"seriesCount":0,
     "podcastCount":0,"numIssues":0,"loadedAt":1000}
    """

    static let library = """
    {"id":"library-1","name":"Books","folders":[],"displayOrder":1,"icon":"books-1",
     "mediaType":"book","provider":"google","settings":{"coverAspectRatio":0,"disableWatcher":false,
      "markAsFinishedPercentComplete":95.5,"markAsFinishedTimeRemaining":12.25},
     "createdAt":1000,"lastUpdate":2000}
    """

    static func data(_ json: String) -> Data { Data(json.utf8) }

    static func object(_ json: String) throws -> [String: Any] {
        try #require(JSONSerialization.jsonObject(with: data(json)) as? [String: Any])
    }

    static func json(_ object: [String: Any]) throws -> String {
        try #require(String(
            data: JSONSerialization.data(withJSONObject: object, options: [.sortedKeys]), encoding: .utf8
        ))
    }

    static func changed(_ json: String, key: String, value: Any?) throws -> String {
        var object = try object(json)
        object[key] = value
        return try self.json(object)
    }

    static func encoded<T: Encodable>(_ value: T) throws -> [String: Any] {
        try #require(JSONSerialization.jsonObject(with: JSONEncoder().encode(value)) as? [String: Any])
    }

    static func decode<T: Decodable>(_ type: T.Type, _ json: String) throws -> T {
        try JSONDecoder().decode(type, from: data(json))
    }

    static func response<T: Interface>(_ type: T.Type, _ json: String, status: Int = 200) throws -> T.Response {
        let url = try #require(URL(string: "https://example.invalid"))
        let response = try #require(HTTPURLResponse(
            url: url, statusCode: status, httpVersion: nil, headerFields: nil
        ))
        return try type.handle((data: data(json), response: response))
    }

}
