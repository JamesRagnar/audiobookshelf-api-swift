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

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public let body: RequestBody? = nil

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

    public enum AudiobookshelfError: Error {
        case badRequest
        case notFound
    }

    public static let responseCases: ResponseCases = [
        200: .success(Response.self),
        400: .failure(AudiobookshelfError.badRequest),
        404: .failure(AudiobookshelfError.notFound)
    ]
}
