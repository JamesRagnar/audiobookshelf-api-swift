//
//  CheckNewPodcastEpisodes.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Checks RSS and queues new episode downloads on 2.26.0+; this GET mutates state.
public struct CheckNewPodcastEpisodes: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Check New Podcast Episodes Request
        ///
        /// - Parameters:
        ///   - podcastId: Required podcast library-item ID.
        ///   - limit: Optional wire query limit; nil uses 3. Positive values limit downloads;
        ///     zero (normal no-limit choice) and negative values mean no limit.
        public init(podcastId: String, limit: Int? = nil) {
            self.path = "/api/podcasts/\(podcastId)/checknew"
            self.queryItems = limit.map { [URLQueryItem(name: "limit", value: String($0))] }
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// The new episodes found in the RSS feed.
        public let episodes: [PodcastFeedEpisode]

    }

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

extension CheckNewPodcastEpisodes {

    /// Legacy RSS response name; now exposes the complete parsed episode.
    @available(*, deprecated, renamed: "PodcastFeedEpisode")
    public typealias RssPodcastEpisode = PodcastFeedEpisode

}
