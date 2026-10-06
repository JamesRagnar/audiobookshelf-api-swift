import AudiobookshelfAPI
import Foundation
import Testing

private typealias Fixtures = MaintainedContractFixtures

@Suite
struct PodcastRSSContractTests {

    @Test
    func completeFeedConversionEncodesABareDownloadArray() throws {
        let episode = try Fixtures.decode(PodcastFeedEpisode.self, Fixtures.rssEpisode)
        let request = DownloadPodcastEpisodes.Request(
            podcastId: "podcast-1", episodes: [.init(feedEpisode: episode)]
        )
        let rows = try #require(JSONSerialization.jsonObject(
            with: JSONEncoder().encode(request.body)
        ) as? [[String: Any]])
        let row = try #require(rows.first)
        let enclosure = try #require(row["enclosure"] as? [String: String])
        #expect(enclosure == ["url": "https://example.invalid/episode.mp3"])
        #expect((row["subtitle"] as? String)?.isEmpty == true)
        #expect((row["descriptionPlain"] as? String)?.isEmpty == true)
        #expect((row["author"] as? String)?.isEmpty == true)
        #expect(row["duration"] as? String == "1.25")
        #expect((row["explicit"] as? String)?.isEmpty == true)
        #expect(row["durationSeconds"] as? Double == 1.25)
        #expect(row["publishedAt"] == nil)
        #expect(row["chaptersUrl"] as? String == "https://example.invalid/chapters.json")
        let chapters = try #require(row["chapters"] as? [[String: Any]])
        #expect(chapters.first?["start"] as? Double == 0.25)
    }

    @Test
    func enclosureOptionalMetadataIsOmittedOrExplicitlySent() throws {
        let minimal = try Fixtures.encoded(PodcastEpisodeEnclosurePayload(url: "url"))
        let complete = try Fixtures.encoded(PodcastEpisodeEnclosurePayload(
            url: "url", type: "audio/mpeg", length: "1234"
        ))
        #expect(Set(minimal.keys) == ["url"])
        #expect(complete as? [String: String] == ["url": "url", "type": "audio/mpeg", "length": "1234"])
    }

    @Test(arguments: ["enclosure", "chapters", "title", "duration"])
    func parsedRSSRequiresNormalizedFields(key: String) throws {
        let json = try Fixtures.changed(Fixtures.rssEpisode, key: key, value: nil)
        #expect(throws: DecodingError.self) { try Fixtures.decode(PodcastFeedEpisode.self, json) }
    }

    @Test(arguments: [0, 2])
    func searchAllowsEmptyAndMultipleRSSMatches(count: Int) throws {
        let entries = Array(repeating: Fixtures.rssEpisode, count: count).joined(separator: ",")
        let response = try Fixtures.response(SearchPodcastEpisode.self, "{\"episodes\":[\(entries)]}")
        #expect(response.episodes.count == count)
    }

    @Test(arguments: [nil, 0, -1, 3, 10] as [Int?])
    func checkNewEncodesOptionalLimitAndReturnsCompleteRSS(limit: Int?) throws {
        let request = CheckNewPodcastEpisodes.Request(podcastId: "podcast-1", limit: limit)
        #expect(request.queryItems?["limit"] == limit.map(String.init))
        let response = try Fixtures.response(
            CheckNewPodcastEpisodes.self, "{\"episodes\":[\(Fixtures.rssEpisode)]}"
        )
        #expect(response.episodes.first?.enclosure.url == "https://example.invalid/episode.mp3")
        #expect(response.episodes.first?.durationSeconds == 1.25)
    }

    @Test
    func feedLookupSendsOnlyRSSURL() throws {
        let request = GetPodcastFeed.Request(rssFeed: "https://example.invalid/feed")
        #expect(try Fixtures.encoded(request.body) as? [String: String]
                    == ["rssFeed": "https://example.invalid/feed"])
    }

    @Test
    func creationEncodesMediaLevelSettingsAndOmitsUpdateOnlyLimits() throws {
        let request = CreatePodcast.Request(
            libraryId: "library-1", folderId: "folder-1", path: "/podcasts",
            metadata: .init(title: "Podcast", itunesId: "123", explicit: false),
            tags: [], autoDownloadEpisodes: false, autoDownloadSchedule: "0 0 * * *"
        )
        let media = try #require(Fixtures.encoded(request.body)["media"] as? [String: Any])
        #expect(media["tags"] as? [String] == [])
        #expect(media["autoDownloadEpisodes"] as? Bool == false)
        #expect(media["autoDownloadSchedule"] as? String == "0 0 * * *")
        #expect(media["maxEpisodesToKeep"] == nil)
        #expect(media["maxNewEpisodesToDownload"] == nil)
        let metadata = try #require(media["metadata"] as? [String: Any])
        #expect(metadata["itunesId"] as? String == "123")
        let minimal = CreatePodcast.Request(
            libraryId: "library-1", folderId: "folder-1", path: "/podcasts", metadata: .init()
        )
        let minimalMedia = try #require(Fixtures.encoded(minimal.body)["media"] as? [String: Any])
        #expect(minimalMedia["tags"] == nil)
        #expect(minimalMedia["autoDownloadEpisodes"] == nil)
        #expect(minimalMedia["autoDownloadSchedule"] == nil)
    }

    @Test
    func chaptersArePubliclyConstructibleForDownloadWrites() throws {
        let entry = DownloadPodcastEpisodes.EpisodeToDownload(
            title: "Episode", enclosure: .init(url: "url"),
            chapters: [.init(id: 0, start: 0.25, end: 1.5, title: "Intro")]
        )
        let chapters = try #require(Fixtures.encoded(entry)["chapters"] as? [[String: Any]])
        #expect(chapters.first?["end"] as? Double == 1.5)
    }

}
