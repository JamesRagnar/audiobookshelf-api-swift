//
//  GetYourBookmarks.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-07-27.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves every bookmark on your user, across all library items.
///
/// Use `GetYourBookmarksForLibraryItem` to scope the result to a single item.
///
/// - Note: Requires server `>= 2.36.0`.
public struct GetYourBookmarks: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String = "/api/me/bookmarks"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Get Your Bookmarks Request
        public init() {}

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// Every bookmark on your user. Empty if there are none.
        public let bookmarks: [AudioBookmark]

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200)
    )

}
