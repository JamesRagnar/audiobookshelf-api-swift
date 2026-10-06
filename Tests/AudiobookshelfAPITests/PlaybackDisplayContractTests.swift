import AudiobookshelfAPI
import Foundation
import Testing

private typealias Fixtures = MaintainedContractFixtures

@Suite
struct PlaybackDisplayContractTests {

    @Test(arguments: ["2.26.0", "2.36.1", "2.37.1"], [0, 2])
    func bookPlaybackAcceptsNullDisplayFields(version: String, playMethod: Int) throws {
        let json = try session(Self.bookSession, version: version, playMethod: playMethod)
        let response = try Fixtures.response(StartPlaybackSession.self, json)
        #expect(response.displayTitle == nil)
        #expect(response.displayAuthor == "Author")
        #expect(response.id == "book-session")
        #expect(response.audioTracks?.first?.duration == 120.5)
        #expect(response.playMethod.rawValue == playMethod)
        #expect(response.serverVersion == version)
    }

    @Test(arguments: ["2.26.0", "2.36.1", "2.37.1"], [0, 2])
    func episodePlaybackAcceptsNullDisplayFields(version: String, playMethod: Int) throws {
        let json = try session(Self.episodeSession, version: version, playMethod: playMethod)
        let response = try Fixtures.response(StartEpisodePlaybackSession.self, json)
        #expect(response.displayTitle == "Episode")
        #expect(response.displayAuthor == nil)
        #expect(response.episodeId == "episode-1")
        #expect(response.audioTracks?.first?.duration == 120.5)
        #expect(response.playMethod.rawValue == playMethod)
        #expect(response.serverVersion == version)
    }

    @Test(arguments: [("Title", "Author"), ("", "")])
    func playbackPreservesDisplayStrings(title: String, author: String) throws {
        let book = try displayStrings(Self.bookSession, title: title, author: author)
        let episode = try displayStrings(Self.episodeSession, title: title, author: author)
        let bookResponse = try Fixtures.response(StartPlaybackSession.self, book)
        let episodeResponse = try Fixtures.response(StartEpisodePlaybackSession.self, episode)
        #expect(bookResponse.displayTitle == title)
        #expect(bookResponse.displayAuthor == author)
        #expect(episodeResponse.displayTitle == title)
        #expect(episodeResponse.displayAuthor == author)
    }

    @Test(arguments: ["displayTitle", "displayAuthor"], ["1", "true", "[]", "{}"])
    func playbackRejectsNonStringDisplayFields(key: String, raw: String) throws {
        let value = try JSONSerialization.jsonObject(with: Data(raw.utf8), options: [.fragmentsAllowed])
        let book = try Fixtures.changed(
            displayStrings(Self.bookSession, title: "Title", author: "Author"), key: key, value: value
        )
        let episode = try Fixtures.changed(
            displayStrings(Self.episodeSession, title: "Title", author: "Author"), key: key, value: value
        )
        #expect(throws: (any Error).self) { try Fixtures.response(StartPlaybackSession.self, book) }
        #expect(throws: (any Error).self) { try Fixtures.response(StartEpisodePlaybackSession.self, episode) }
    }

    private func session(_ json: String, version: String, playMethod: Int) throws -> String {
        var object = try Fixtures.object(json)
        object["serverVersion"] = version
        object["playMethod"] = playMethod
        return try Fixtures.json(object)
    }

    private func displayStrings(_ json: String, title: String, author: String) throws -> String {
        var object = try Fixtures.object(json)
        object["displayTitle"] = title
        object["displayAuthor"] = author
        return try Fixtures.json(object)
    }

    private static let bookSession = """
    {"id":"book-session","userId":"user-1","libraryId":"library-1","libraryItemId":"item-1",
     "episodeId":null,"bookId":"book-1","mediaType":"book",
     "mediaMetadata":{"title":null,"authorName":"Author","genres":[]},
     "chapters":[],"displayTitle":null,"displayAuthor":"Author","coverPath":null,
     "duration":120.5,"playMethod":0,"mediaPlayer":"browser",
     "deviceInfo":{"id":"device-1","deviceId":"browser-1","clientName":"Browser"},
     "serverVersion":"2.37.1","date":"2026-01-01","dayOfWeek":"Thursday","timeListening":0,
     "startTime":0,"currentTime":0,"startedAt":1000,"updatedAt":1000,
     "audioTracks":[{"index":1,"startOffset":0,"duration":120.5,"title":"book.mp3",
      "contentUrl":"/api/items/item-1/file/audio","mimeType":"audio/mpeg","codec":"mp3","metadata":null}],
     "videoTrack":null,"libraryItem":null}
    """

    private static let episodeSession = """
    {"id":"episode-session","userId":"user-1","libraryId":"library-1","libraryItemId":"podcast-1",
     "episodeId":"episode-1","bookId":null,"mediaType":"podcast",
     "mediaMetadata":{"title":"Podcast","author":null,"genres":[]},
     "chapters":null,"displayTitle":"Episode","displayAuthor":null,"coverPath":null,
     "duration":120.5,"playMethod":0,"mediaPlayer":"browser",
     "deviceInfo":{"id":"device-1","deviceId":"browser-1","clientName":"Browser"},
     "serverVersion":"2.37.1","date":"2026-01-01","dayOfWeek":"Thursday","timeListening":0,
     "startTime":0,"currentTime":0,"startedAt":1000,"updatedAt":1000,
     "audioTracks":[{"index":1,"startOffset":0,"duration":120.5,"title":"episode.mp3",
      "contentUrl":"/api/items/podcast-1/file/audio","mimeType":"audio/mpeg","codec":"mp3","metadata":null}],
     "videoTrack":null,"libraryItem":null}
    """

}
