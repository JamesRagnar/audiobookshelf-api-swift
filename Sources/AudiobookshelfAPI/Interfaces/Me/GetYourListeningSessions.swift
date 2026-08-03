//
//  GetYourListeningSessions.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-21.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves your listening sessions.
public struct GetYourListeningSessions: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String = "/api/me/listening-sessions"

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Get Your Listening Sessions Request
        /// 
        /// - Parameters:
        ///   - itemsPerPage: The number of listening sessions to retrieve per page.
        ///   - page: The page (0 indexed) to retrieve.
        public init(
            itemsPerPage: Int,
            page: Int
        ) {
            self.queryItems = [
                URLQueryItem(name: "itemsPerPage", value: itemsPerPage.description),
                URLQueryItem(name: "page", value: page.description)
            ]
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// The total number of listening sessions.
        public let total: Int

        /// The total number of pages when using this itemsPerPage limit.
        public let numPages: Int

        /// The provided itemsPerPage parameter.
        public let itemsPerPage: Int

        /// The requested listening sessions.
        public let sessions: [PlaybackSession]

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200)
    )

}
