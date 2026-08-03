//
//  DownloadPodcastEpisodes.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// This endpoint queues podcast episodes for download.
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

        case forbidden

        case notFound

        /// The library item exists but is not a podcast.
        case internalServerError

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound)),
            .code(500, .error(AudiobookshelfError.internalServerError))
        ]
    )

}

extension DownloadPodcastEpisodes {

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

        public init(
            title: String,
            subtitle: String? = nil,
            description: String? = nil,
            pubDate: String? = nil,
            episode: String? = nil,
            season: String? = nil,
            episodeType: String? = nil,
            guid: String? = nil,
            publishedAt: Int? = nil
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
        }

    }

}

public extension DownloadPodcastEpisodes.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let episodes: [DownloadPodcastEpisodes.EpisodeToDownload]

    }

}
