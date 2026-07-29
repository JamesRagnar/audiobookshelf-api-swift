import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

@Suite
struct PodcastEpisodeUpdateTests {

    // MARK: Enclosure Decoding

    @Test
    func enclosureDecodesFullFeedShape() throws {
        let data = Data(
            """
            {
              "url": "https://example.com/episode.mp3",
              "type": "audio/mpeg",
              "length": "18234567"
            }
            """.utf8
        )

        let enclosure = try JSONDecoder().decode(PodcastEpisodeEnclosure.self, from: data)

        #expect(enclosure.url == "https://example.com/episode.mp3")
        #expect(enclosure.type == "audio/mpeg")
        #expect(enclosure.length == "18234567")
    }

    @Test
    func enclosureDecodesNullTypeAndLength() throws {
        // Reachable from 2.36.0 onward, where an enclosure can be set with only a URL
        let data = Data(
            """
            {
              "url": "https://example.com/episode.mp3",
              "type": null,
              "length": null
            }
            """.utf8
        )

        let enclosure = try JSONDecoder().decode(PodcastEpisodeEnclosure.self, from: data)

        #expect(enclosure.url == "https://example.com/episode.mp3")
        #expect(enclosure.type == nil)
        #expect(enclosure.length == nil)
    }

    // MARK: Update Payload Encoding

    @Test
    func updatePayloadOmitsUnsetFields() throws {
        let parameters = UpdatePodcastEpisode.Parameters(
            podcastId: "podcast-1",
            episodeId: "episode-1",
            title: "New Title"
        )

        #expect(parameters.path == "/api/podcasts/podcast-1/episode/episode-1")

        let object = try encodeToObject(parameters.body)

        #expect(object.keys.sorted() == ["title"])
        #expect(object["title"] as? String == "New Title")
    }

    @Test
    func updatePayloadEncodesEnclosureObjectWhenSet() throws {
        let parameters = UpdatePodcastEpisode.Parameters(
            podcastId: "podcast-1",
            episodeId: "episode-1",
            enclosure: .set(.init(
                url: "https://example.com/episode.mp3",
                type: "audio/mpeg",
                length: "18234567"
            ))
        )

        let object = try encodeToObject(parameters.body)
        let enclosure = try #require(object["enclosure"] as? [String: Any])

        #expect(enclosure["url"] as? String == "https://example.com/episode.mp3")
        #expect(enclosure["type"] as? String == "audio/mpeg")
        #expect(enclosure["length"] as? String == "18234567")
    }

    @Test
    func updatePayloadEncodesExplicitNullWhenCleared() throws {
        let parameters = UpdatePodcastEpisode.Parameters(
            podcastId: "podcast-1",
            episodeId: "episode-1",
            enclosure: .clear
        )

        let object = try encodeToObject(parameters.body)

        // The server distinguishes an absent key from an explicit null, and only the latter clears
        // the stored enclosure URL, type and size.
        #expect(object.keys.contains("enclosure"))
        #expect(object["enclosure"] is NSNull)
    }

    // MARK: Response

    @Test
    func updateResponseDecodesLibraryItemNotEpisode() throws {
        let body = Data(
            """
            {
              "id": "library-item-1",
              "ino": "1234",
              "libraryId": "library-1",
              "folderId": "folder-1",
              "path": "/podcasts/Example",
              "relPath": "Example",
              "isFile": false,
              "addedAt": 1737000000000,
              "updatedAt": 1737600000000,
              "isMissing": false,
              "isInvalid": false,
              "mediaType": "podcast",
              "media": {
                "id": "podcast-1",
                "libraryItemId": "library-item-1",
                "metadata": { "title": "Example", "genres": [], "titleIgnorePrefix": "Example" },
                "tags": [],
                "episodes": [],
                "autoDownloadEpisodes": false,
                "maxEpisodesToKeep": 0,
                "maxNewEpisodesToDownload": 3,
                "numEpisodes": 0,
                "size": 0
              },
              "libraryFiles": [],
              "numFiles": 0,
              "size": 0
            }
            """.utf8
        )

        let decoded = try UpdatePodcastEpisode.handle(
            (data: body, response: makeResponse(statusCode: 200))
        )

        #expect(decoded.id == "library-item-1")
        #expect(decoded.mediaType == .podcast)
        #expect(decoded.numFiles == 0)
    }

    // MARK: Helpers

    private func encodeToObject(_ value: some Encodable) throws -> [String: Any] {
        let data = try JSONEncoder().encode(value)
        let object = try JSONSerialization.jsonObject(with: data)
        return try #require(object as? [String: Any])
    }

    private func makeResponse(statusCode: Int) throws -> URLResponse {
        let url = try #require(URL(string: "https://example.com"))
        return try #require(HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        ))
    }

}
