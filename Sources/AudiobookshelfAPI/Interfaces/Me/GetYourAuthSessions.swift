//
//  GetYourAuthSessions.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-07-27.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves your active authentication sessions, one per device that holds a refresh token.
///
/// Use `DeleteYourAuthSession` to log out an individual device.
///
/// - Note: Requires server `>= 2.36.0`. Guest users always receive an empty page rather than an error.
public struct GetYourAuthSessions: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/api/me/sessions"

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]?

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// Get Your Auth Sessions Parameters
        ///
        /// - Parameters:
        ///   - itemsPerPage: The number of sessions to retrieve per page.
        ///   - page: The page (0 indexed) to retrieve.
        ///   - refreshToken: The JWT refresh token for the current session. When provided, the server can
        ///     mark the matching session with `current`. Without it, every session reports `current` as
        ///     false.
        public init(
            itemsPerPage: Int,
            page: Int,
            refreshToken: String? = nil
        ) {
            self.queryItems = [
                URLQueryItem(name: "itemsPerPage", value: itemsPerPage.description),
                URLQueryItem(name: "page", value: page.description)
            ]

            if let refreshToken {
                self.headers = ["x-refresh-token": refreshToken]
            } else {
                self.headers = nil
            }
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        /// The total number of active sessions.
        public let total: Int

        /// The total number of pages when using this itemsPerPage limit.
        public let numPages: Int

        /// The provided page parameter.
        public let page: Int

        /// The provided itemsPerPage parameter.
        public let itemsPerPage: Int

        /// The requested sessions, ordered by most recently refreshed first.
        public let sessions: [AuthSession]

    }

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .decode)
    ]

}
