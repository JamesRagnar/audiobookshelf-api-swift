//
//  DownloadPodcastEpisodes.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Queues a nonempty bare array of RSS episodes for download on 2.26.0+.
/// HTTP 200 acknowledges acceptance, not completed asynchronous downloads.
public struct DownloadPodcastEpisodes: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Download Podcast Episodes Request
        ///
        /// - Parameters:
        ///   - podcastId: The ID of the podcast library item.
        ///   - episodes: The episodes to download.
        public init(
            podcastId: String,
            episodes: [EpisodeToDownload]
        ) {
            self.path = "/api/podcasts/\(podcastId)/download-episodes"
            self.body = Payload(episodes: episodes)
        }

    }

    // MARK: Response

    public typealias Response = String

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

        case notFound

        /// The library item exists but is not a podcast.
        case internalServerError

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound)),
            .code(500, .error(AudiobookshelfError.internalServerError))
        ]
    )

}

extension DownloadPodcastEpisodes {

    /// Complete normalized RSS-to-download conversion preserves all parsed metadata.
    public struct EpisodeToDownload: Encodable, Sendable {

        /// The title of the episode.
        public let title: String

        /// The subtitle of the episode.
        public let subtitle: String?

        /// A description of the episode.
        public let description: String?

        /// When the episode was published.
        public let pubDate: String?

        /// The episode number.
        public let episode: String?

        /// The season number.
        public let season: String?

        /// The type of episode.
        public let episodeType: String?

        /// The globally unique identifier for the episode.
        public let guid: String?

        /// The time (in ms since POSIX epoch) when the episode was published.
        public let publishedAt: Int?

        /// Wire enclosure, 2.26.0+; required download URL and optional MIME/byte length.
        public let enclosure: PodcastEpisodeEnclosurePayload

        /// Wire descriptionPlain, 2.26.0+; nil omits; copied from parsed RSS.
        public let descriptionPlain: String?

        /// Wire author, 2.26.0+; nil omits; copied from parsed RSS.
        public let author: String?

        /// Wire duration, 2.26.0+; optional original RSS duration string; nil omits.
        public let duration: String?

        /// Wire durationSeconds, 2.26.0+; optional parsed fractional seconds; nil omits.
        public let durationSeconds: Double?

        /// Wire explicit, 2.26.0+; original RSS explicit string, not Boolean; nil omits.
        public let explicit: String?

        /// Wire chaptersUrl, 2.26.0+; optional external chapter URL; nil omits.
        public let chaptersUrl: String?

        /// Wire chaptersType, 2.26.0+; optional chapter MIME type; nil omits.
        public let chaptersType: String?

        /// Wire chapters, 2.26.0+; optional list with start/end in fractional seconds; nil omits.
        public let chapters: [BookChapter]?

        /// Creates a download entry on 2.26.0+; optional nil values omit their matching wire keys.
        /// - Parameters:
        ///   - title: Required episode title.
        ///   - subtitle: Optional subtitle.
        ///   - description: Optional HTML description.
        ///   - pubDate: Optional original RSS publication string.
        ///   - episode: Optional episode-number string.
        ///   - season: Optional season-number string.
        ///   - episodeType: Optional RSS episode-type string.
        ///   - guid: Optional RSS identifier.
        ///   - publishedAt: Optional epoch milliseconds.
        ///   - enclosure: Required download URL with optional MIME type and byte-count string.
        ///   - descriptionPlain: Optional plain description.
        ///   - author: Optional RSS author name.
        ///   - duration: Optional original duration string.
        ///   - durationSeconds: Optional parsed fractional seconds.
        ///   - explicit: Optional RSS explicit string; not a stored Boolean.
        ///   - chaptersUrl: Optional external chapter URL.
        ///   - chaptersType: Optional external chapter MIME type.
        ///   - chapters: Optional chapter list with fractional-second positions; [] is explicit.
        public init(
            title: String,
            subtitle: String? = nil,
            description: String? = nil,
            pubDate: String? = nil,
            episode: String? = nil,
            season: String? = nil,
            episodeType: String? = nil,
            guid: String? = nil,
            publishedAt: Int? = nil,
            enclosure: PodcastEpisodeEnclosurePayload,
            descriptionPlain: String? = nil,
            author: String? = nil,
            duration: String? = nil,
            durationSeconds: Double? = nil,
            explicit: String? = nil,
            chaptersUrl: String? = nil,
            chaptersType: String? = nil,
            chapters: [BookChapter]? = nil
        ) {
            self.title = title
            self.subtitle = subtitle
            self.description = description
            self.pubDate = pubDate
            self.episode = episode
            self.season = season
            self.episodeType = episodeType
            self.guid = guid
            self.publishedAt = publishedAt
            self.enclosure = enclosure
            self.descriptionPlain = descriptionPlain
            self.author = author
            self.duration = duration
            self.durationSeconds = durationSeconds
            self.explicit = explicit
            self.chaptersUrl = chaptersUrl
            self.chaptersType = chaptersType
            self.chapters = chapters
        }

        /// Copies the complete RSS result, including its required enclosure.
        public init(feedEpisode: PodcastFeedEpisode) {
            self.init(
                title: feedEpisode.title, subtitle: feedEpisode.subtitle,
                description: feedEpisode.description, pubDate: feedEpisode.pubDate,
                episode: feedEpisode.episode, season: feedEpisode.season,
                episodeType: feedEpisode.episodeType, guid: feedEpisode.guid,
                publishedAt: feedEpisode.publishedAt,
                enclosure: .init(url: feedEpisode.enclosure.url, type: feedEpisode.enclosure.type,
                                 length: feedEpisode.enclosure.length),
                descriptionPlain: feedEpisode.descriptionPlain, author: feedEpisode.author,
                duration: feedEpisode.duration, durationSeconds: feedEpisode.durationSeconds,
                explicit: feedEpisode.explicit, chaptersUrl: feedEpisode.chaptersUrl,
                chaptersType: feedEpisode.chaptersType, chapters: feedEpisode.chapters
            )
        }

    }

}

public extension DownloadPodcastEpisodes.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let episodes: [DownloadPodcastEpisodes.EpisodeToDownload]

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(episodes)
        }

    }

}
