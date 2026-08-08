import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct ListeningStatsDecodingTests {

    @Test
    func podcastMetadataUsesPodcastBranch() throws {
        let item = try decode(
            """
            {
              "id": "podcast-1",
              "timeListening": 120,
              "mediaMetadata": {
                "title": "Example Podcast",
                "author": "Example Host",
                "genres": ["Technology"],
                "feedUrl": "https://example.com/feed.xml"
              }
            }
            """
        )

        let podcast = try #require(item.mediaMetadata.podcast)
        #expect(podcast.title == "Example Podcast")
        #expect(podcast.author == "Example Host")
        #expect(item.mediaMetadata.book == nil)
    }

    @Test
    func bookMetadataUsesBookBranch() throws {
        let item = try decode(
            """
            {
              "id": "book-1",
              "timeListening": 240,
              "mediaMetadata": {
                "title": "Example Book",
                "genres": ["Fiction"],
                "isbn": "9780000000000"
              }
            }
            """
        )

        let book = try #require(item.mediaMetadata.book)
        #expect(book.title == "Example Book")
        #expect(book.isbn == "9780000000000")
        #expect(item.mediaMetadata.podcast == nil)
    }

    private func decode(_ json: String) throws -> GetYourListeningStats.Response.ListenedItem {
        try JSONDecoder().decode(
            GetYourListeningStats.Response.ListenedItem.self,
            from: Data(json.utf8)
        )
    }

}
