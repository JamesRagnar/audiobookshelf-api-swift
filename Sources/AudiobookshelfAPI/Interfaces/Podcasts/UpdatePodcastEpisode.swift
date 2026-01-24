//
//  UpdatePodcastEpisode.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Update podcast episode metadata.
public struct UpdatePodcastEpisode: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        /// Update Podcast Episode Parameters
        ///
        /// - Parameters:
        ///   - podcastId: The ID of the podcast library item.
        ///   - episodeId: The ID of the podcast episode.
        ///   - title: The new title of the episode.
        ///   - subtitle: The new subtitle of the episode.
        ///   - description: The new description of the episode.
        ///   - publishedAt: The time (in ms since POSIX epoch) when the episode was published.
        public init(
            podcastId: String,
            episodeId: String,
            title: String? = nil,
            subtitle: String? = nil,
            description: String? = nil,
            publishedAt: Int? = nil
        ) throws {
            self.path = "/api/podcasts/\(podcastId)/episode/\(episodeId)"
            self.body = try JSONEncoder().encode(
                Body(
                    title: title,
                    subtitle: subtitle,
                    description: description,
                    publishedAt: publishedAt
                )
            )
        }

    }

    // MARK: Response

    public typealias Response = PodcastEpisode

    public enum AudiobookshelfError: Error {

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        404: .failure(AudiobookshelfError.notFound),

    ]

}

extension UpdatePodcastEpisode.Parameters {

    struct Body: Encodable {

        let title: String?

        let subtitle: String?

        let description: String?

        let publishedAt: Int?

    }

}
