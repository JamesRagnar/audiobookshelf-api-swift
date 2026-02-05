//
//  GetRecentEpisodes.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// This endpoint returns the most recent podcast episodes in a library.
public struct GetRecentEpisodes: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [String: String?]?

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Get Recent Episodes Parameters
        /// - Parameters:
        ///   - libraryId: The ID of the library.
        ///   - limit: The maximum number of episodes to return.
        ///   - page: The page number (0 indexed) to request.
        public init(
            libraryId: String,
            limit: Int? = nil,
            page: Int? = nil
        ) {
            self.path = "/api/libraries/\(libraryId)/recent-episodes"

            var queryItems: [String: String?] = [:]
            queryItems.setIfPresent("limit", limit?.description)
            queryItems.setIfPresent("page", page?.description)
            self.queryItems = queryItems.isEmpty ? nil : queryItems
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        /// The recent podcast episodes.
        public let episodes: [PodcastEpisode]

        /// The total number of episodes.
        public let total: Int

        /// The limit set in the request.
        public let limit: Int

        /// The page set in the request.
        public let page: Int

    }

    public enum AudiobookshelfError: Error {

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        404: .failure(AudiobookshelfError.notFound)

    ]

}
