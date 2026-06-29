import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct MediaProgressDecodingTests {

    // MARK: No media (bare progress)

    @Test
    func bareProgressDecodesWithNoMedia() throws {
        let progress = try decode(bareProgressJSON)

        #expect(progress.id == "mp-1")
        #expect(progress.userId == "user-1")
        #expect(progress.mediaItemId == "book-1")
        #expect(progress.duration == 3600.0)
        #expect(progress.progress == 0.5)
        #expect(progress.currentTime == 1800.0)
        #expect(progress.isFinished == false)
        #expect(progress.hideFromContinueListening == false)
        #expect(progress.media == nil)
        #expect(progress.episodeId == nil)
        #expect(progress.finishedAt == nil)
    }

    // MARK: Book media branch

    @Test
    func bookProgressDecodesBookMedia() throws {
        let json = """
        {
          "id": "mp-2",
          "userId": "user-1",
          "libraryItemId": "li-1",
          "mediaItemId": "book-1",
          "mediaItemType": "book",
          "duration": 3600.0,
          "progress": 1.0,
          "currentTime": 3600.0,
          "isFinished": true,
          "hideFromContinueListening": false,
          "lastUpdate": 5000,
          "startedAt": 1000,
          "finishedAt": 5000,
          "media": {
            "id": "book-1",
            "metadata": { "title": "Finished Book", "genres": [] },
            "tags": []
          }
        }
        """
        let progress = try decode(json)

        #expect(progress.isFinished == true)
        #expect(progress.finishedAt == 5000)

        guard case .book(let book) = progress.media else {
            Issue.record("Expected book media")
            return
        }
        #expect(book.id == "book-1")
        #expect(book.metadata.title == "Finished Book")
    }

    // MARK: Podcast media branch — episodeId drives the switch

    @Test
    func podcastProgressDecodesPodcastMedia() throws {
        let json = """
        {
          "id": "mp-3",
          "userId": "user-1",
          "libraryItemId": "li-2",
          "episodeId": "ep-1",
          "mediaItemId": "ep-1",
          "mediaItemType": "podcastEpisode",
          "duration": 1800.0,
          "progress": 0.2,
          "currentTime": 360.0,
          "isFinished": false,
          "hideFromContinueListening": false,
          "lastUpdate": 2000,
          "startedAt": 1000,
          "media": {
            "id": "podcast-1",
            "metadata": { "title": "Test Podcast", "genres": [] },
            "tags": [],
            "autoDownloadEpisodes": false,
            "maxEpisodesToKeep": 0,
            "maxNewEpisodesToDownload": 0
          }
        }
        """
        let progress = try decode(json)

        #expect(progress.episodeId == "ep-1")

        guard case .podcast(let podcast) = progress.media else {
            Issue.record("Expected podcast media")
            return
        }
        #expect(podcast.id == "podcast-1")
        #expect(podcast.metadata.title == "Test Podcast")
    }

    // MARK: Empty episodeId does not trigger podcast branch

    @Test
    func emptyEpisodeIdFallsBackToBookMedia() throws {
        let json = """
        {
          "id": "mp-4",
          "userId": "user-1",
          "episodeId": "",
          "mediaItemId": "book-1",
          "mediaItemType": "book",
          "duration": 3600.0,
          "progress": 0.1,
          "currentTime": 360.0,
          "isFinished": false,
          "hideFromContinueListening": false,
          "lastUpdate": 2000,
          "startedAt": 1000,
          "media": {
            "id": "book-1",
            "metadata": { "title": "A Book", "genres": [] },
            "tags": []
          }
        }
        """
        let progress = try decode(json)

        guard case .book = progress.media else {
            Issue.record("Empty episodeId should not trigger podcast branch")
            return
        }
    }

    // MARK: Missing required field throws

    @Test
    func missingMediaItemIdThrows() {
        let json = bareProgressJSON.replacingOccurrences(of: "\"mediaItemId\": \"book-1\",", with: "")
        #expect(throws: (any Error).self) {
            try decode(json)
        }
    }

    // MARK: Helpers

    private func decode(_ json: String) throws -> MediaProgress {
        try JSONDecoder().decode(MediaProgress.self, from: Data(json.utf8))
    }

}

// MARK: Fixtures

private let bareProgressJSON = """
{
  "id": "mp-1",
  "userId": "user-1",
  "mediaItemId": "book-1",
  "mediaItemType": "book",
  "duration": 3600.0,
  "progress": 0.5,
  "currentTime": 1800.0,
  "isFinished": false,
  "hideFromContinueListening": false,
  "lastUpdate": 2000,
  "startedAt": 1000
}
"""
