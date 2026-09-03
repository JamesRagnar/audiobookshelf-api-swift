//
//  GetAllSessions.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-23.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves all playback sessions for the authenticated user.
public struct GetAllSessions: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public enum Sort: String, CaseIterable, Sendable {

            case displayTitle

            case duration

            case playMethod

            case startTime

            case currentTime

            case timeListening

            case updatedAt

            case createdAt

        }

        public let method: RequestMethod = .get

        public let path: String = "/api/sessions"

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Get all playback sessions.
        /// - Parameters:
        ///   - user: The user ID to filter by. The server only applies this filter for valid user IDs.
        ///   - page: The page number (0 indexed) to request.
        ///   - itemsPerPage: The number of sessions to return per page.
        ///   - sort: The field to sort sessions by. The server defaults to updatedAt when omitted.
        ///   - descending: Whether to reverse the sort order. The server defaults to ascending.
        public init(
            user: String? = nil,
            page: Int? = nil,
            itemsPerPage: Int? = nil,
            sort: Sort? = nil,
            descending: Bool? = nil
        ) {
            var queryItems: [URLQueryItem] = []
            queryItems.appendIfPresent("user", user)
            queryItems.appendIfPresent("page", page?.description)
            queryItems.appendIfPresent("itemsPerPage", itemsPerPage?.description)
            queryItems.appendIfPresent("sort", sort?.rawValue)
            queryItems.appendIfPresent("desc", descending?.binaryString)
            self.queryItems = queryItems.isEmpty ? nil : queryItems
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// The total number of matching sessions.
        public let total: Int

        /// The total number of pages when using this itemsPerPage limit.
        public let numPages: Int

        /// The provided page parameter.
        public let page: Int

        /// The provided itemsPerPage parameter.
        public let itemsPerPage: Int

        /// The requested sessions.
        public let sessions: [PlaybackSession]

        /// Echoed back only when the request filtered by user.
        public let userId: String?

    }

    public enum AudiobookshelfError: Error, Sendable {

        case unauthorized

        /// Returned instead of 403 when the user is not an admin.
        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            /// Unauthorized
            .code(401, .error(AudiobookshelfError.unauthorized)),
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}
