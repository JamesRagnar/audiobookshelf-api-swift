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

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

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

            var queryItems: [URLQueryItem] = []
            queryItems.appendIfPresent("limit", limit?.description)
            queryItems.appendIfPresent("page", page?.description)
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

    public enum AudiobookshelfError: Error, Sendable {

        /// The `limit` or `page` query parameter was not a non-negative integer.
        case badRequest

        /// You do not have access to this library.
        case forbidden

        case notFound

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}
