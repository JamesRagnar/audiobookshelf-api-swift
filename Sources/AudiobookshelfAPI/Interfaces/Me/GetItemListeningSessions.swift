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

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Get Item Listening Sessions Parameters
        /// - Parameters:
        ///   - libraryItemId: The ID of the library item.
        ///   - episodeId: The ID of the podcast episode (optional).
        public init(
            libraryItemId: String,
            episodeId: String? = nil
        ) {
            if let episodeId = episodeId {
                self.path = "/api/me/item/listening-sessions/\(libraryItemId)/\(episodeId)"
            } else {
                self.path = "/api/me/item/listening-sessions/\(libraryItemId)"
            }
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        /// The listening sessions.
        public let sessions: [PlaybackSession]

        /// The total number of sessions.
        public let total: Int

        /// The limit set in the request.
        public let limit: Int

        /// The page set in the request.
        public let page: Int

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
    ]

}
