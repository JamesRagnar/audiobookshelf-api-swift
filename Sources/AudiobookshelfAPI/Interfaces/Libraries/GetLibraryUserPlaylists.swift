//
//  GetLibraryUserPlaylists.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-22.
//

import Foundation
import RagnarNetworking

/// This endpoint returns a library's playlists for the authenticated user.
public struct GetLibraryUserPlaylists: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Get Library User Playlists Request
        ///
        /// - Parameters:
        ///   - libraryID: The ID of the library.
        ///   - limit: Limit the number of returned results per page. If 0, no limit will be applied.
        /// - page: The page number (0 indexed) to request. If there is no limit applied, then page will have no effect
        /// and all results will be returned.
        public init(
            libraryID: String,
            limit: Int,
            page: Int
        ) {
            self.path = "/api/libraries/\(libraryID)/playlists"
            self.queryItems = [
                URLQueryItem(name: "limit", value: limit.description),
                URLQueryItem(name: "page", value: page.description)
            ]
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// The requested playlists.
        public let results: [Playlist]

        /// The total number of results.
        public let total: Int

        /// The limit set in the request.
        public let limit: Int

        /// The page set in request.
        public let page: Int

    }

    public enum AudiobookshelfError: Error, Sendable {

        case notFound

        /// The `limit` or `page` query parameter was not a non-negative integer.
        case badRequest

        /// You do not have access to this library.
        case forbidden

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden)),
            /// The user cannot access the library, or no library with the provided ID exists.
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}
