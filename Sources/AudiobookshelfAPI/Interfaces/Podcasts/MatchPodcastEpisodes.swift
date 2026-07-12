//
//  MatchPodcastEpisodes.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2025-01-27.
//

import Foundation
import RagnarNetworking

/// Match and update podcast episode metadata.
public struct MatchPodcastEpisodes: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// Match Podcast Episodes Parameters
        ///
        /// - Parameters:
        ///   - podcastId: The ID of the podcast library item.
        public init(podcastId: String) {
            self.path = "/api/podcasts/\(podcastId)/match-episodes"
        }
    }

    // MARK: Response

    public struct Response: Decodable, Sendable {
        public let numEpisodesUpdated: Int
    }

    public enum AudiobookshelfError: Error, Sendable {
        case badRequest
        case notFound
    }

    public static let responseCases: ResponseMap = [
        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(404, .error(AudiobookshelfError.notFound))
    ]
}
