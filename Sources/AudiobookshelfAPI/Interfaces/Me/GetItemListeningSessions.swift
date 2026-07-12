//
//  GetItemListeningSessions.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves listening sessions for a specific library item or podcast episode.
public struct GetItemListeningSessions: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// Get Item Listening Sessions Parameters
        /// - Parameters:
        ///   - libraryItemId: The ID of the library item.
        ///   - episodeId: The ID of the podcast episode (optional).
        ///   - itemsPerPage: The number of listening sessions to retrieve per page.
        ///   - page: The page (0 indexed) to retrieve.
        public init(
            libraryItemId: String,
            episodeId: String? = nil,
            itemsPerPage: Int? = nil,
            page: Int? = nil
        ) {
            if let episodeId = episodeId {
                self.path = "/api/me/item/listening-sessions/\(libraryItemId)/\(episodeId)"
            } else {
                self.path = "/api/me/item/listening-sessions/\(libraryItemId)"
            }

            var queryItems: [URLQueryItem] = []
            queryItems.appendIfPresent("itemsPerPage", itemsPerPage?.description)
            queryItems.appendIfPresent("page", page?.description)
            self.queryItems = queryItems
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        /// The listening sessions.
        public let sessions: [PlaybackSession]

        /// The total number of sessions.
        public let total: Int

        /// The total number of pages when using this itemsPerPage limit.
        public let numPages: Int

        /// The provided itemsPerPage parameter.
        public let itemsPerPage: Int

        /// The page set in the request.
        public let page: Int

    }

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}
