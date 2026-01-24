//
//  CheckNewPodcastEpisodes.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// This endpoint checks for new podcast episodes from the podcast's RSS feed.
public struct CheckNewPodcastEpisodes: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data? = nil

        public let authentication: AuthenticationType = .bearer

        /// Check New Podcast Episodes Parameters
        ///
        /// - Parameter podcastId: The ID of the podcast library item to check for new episodes.
        public init(podcastId: String) {
            self.path = "/api/podcasts/\(podcastId)/checknew"
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        /// The new episodes found in the RSS feed.
        public let episodes: [RssPodcastEpisode]

    }

    public enum AudiobookshelfError: Error {

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        403: .failure(AudiobookshelfError.forbidden),

        404: .failure(AudiobookshelfError.notFound),

    ]

}

extension CheckNewPodcastEpisodes {

    public struct RssPodcastEpisode: Decodable, Sendable {

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

    }

}
