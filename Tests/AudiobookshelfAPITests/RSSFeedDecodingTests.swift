import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct RSSFeedDecodingTests {

    @Test
    func rssFeedDecodesFullPayload() throws {
        let feed = try decode(
            """
            {
              "id": "E7F5A7E7-8C3A-4A31-BB2D-1A8D6033F001",
              "slug": "feed-slug",
              "userId": "E7F5A7E7-8C3A-4A31-BB2D-1A8D6033F002",
              "entityType": "collection",
              "entityId": "E7F5A7E7-8C3A-4A31-BB2D-1A8D6033F003",
              "coverPath": "/metadata/cover.jpg",
              "serverAddress": "https://example.com",
              "feedUrl": "https://example.com/rss/feed-slug",
              "meta": {
                "title": "Feed Title",
                "description": "Feed Description",
                "author": "Author",
                "imageUrl": "https://example.com/image.jpg",
                "feedUrl": "https://example.com/rss/feed-slug",
                "link": "https://example.com/collections/1",
                "explicit": false,
                "type": "episodic",
                "language": "en",
                "preventIndexing": true,
                "ownerName": "Owner",
                "ownerEmail": "owner@example.com"
              },
              "episodes": [
                {
                  "id": "episode-1",
                  "title": "Episode 1",
                  "description": "Episode Description",
                  "enclosure": {
                    "url": "https://example.com/audio.mp3",
                    "type": "audio/mpeg",
                    "length": "12345"
                  },
                  "pubDate": "Mon, 01 Jan 2024 00:00:00 GMT",
                  "link": "https://example.com/episodes/1",
                  "author": "Host",
                  "explicit": "no",
                  "duration": 60,
                  "season": "1",
                  "episode": "2",
                  "episodeType": "full",
                  "fullPath": "/audio/episode-1.mp3"
                }
              ],
              "createdAt": 100,
              "updatedAt": 200,
              "entityUpdatedAt": 300
            }
            """
        )

        #expect(feed.slug == "feed-slug")
        #expect(feed.userId != nil)
        #expect(feed.meta.ownerEmail == "owner@example.com")
        #expect(feed.episodes?.count == 1)
        #expect(feed.episodes?.first?.enclosure.type == "audio/mpeg")
        #expect(feed.entityUpdatedAt == 300)
    }

    @Test
    func rssFeedDecodesMinifiedPayloadWithRemovedFields() throws {
        let feed = try decode(
            """
            {
              "id": "E7F5A7E7-8C3A-4A31-BB2D-1A8D6033F011",
              "entityType": "series",
              "entityId": "E7F5A7E7-8C3A-4A31-BB2D-1A8D6033F012",
              "feedUrl": "https://example.com/rss/series",
              "meta": {
                "title": "Series Feed",
                "description": null,
                "preventIndexing": false,
                "ownerName": null,
                "ownerEmail": null
              }
            }
            """
        )

        #expect(feed.slug == nil)
        #expect(feed.userId == nil)
        #expect(feed.coverPath == nil)
        #expect(feed.episodes == nil)
        #expect(feed.meta.title == "Series Feed")
        #expect(feed.meta.preventIndexing == false)
    }

    private func decode(_ json: String) throws -> RSSFeed {
        try JSONDecoder().decode(RSSFeed.self, from: Data(json.utf8))
    }
}
