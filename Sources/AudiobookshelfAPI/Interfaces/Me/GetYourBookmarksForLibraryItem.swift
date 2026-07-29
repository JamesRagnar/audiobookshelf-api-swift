//
//  GetYourBookmarksForLibraryItem.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-07-27.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves your bookmarks for a single library item.
///
/// - Note: Requires server `>= 2.36.0`.
public struct GetYourBookmarksForLibraryItem: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// Get Your Bookmarks For Library Item Parameters
        ///
        /// - Parameter libraryItemID: The ID of the library item to retrieve bookmarks for.
        public init(
            libraryItemID: String
        ) {
            self.path = "/api/me/bookmarks/\(libraryItemID)"
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        /// Your bookmarks for the requested library item. Empty if there are none.
        public let bookmarks: [AudioBookmark]

    }

    public enum AudiobookshelfError: Error, Sendable {

        /// You do not have access to the requested library item.
        case forbidden

        /// No library item was found with the given ID.
        case notFound

    }

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .decode),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}
