//
//  DeleteBookmark.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// This endpoint deletes a bookmark at a specific time for a library item.
public struct DeleteBookmark: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil


        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Delete Bookmark Parameters
        ///
        /// - Parameters:
        ///   - libraryItemId: The ID of the library item containing the bookmark.
        ///   - time: The time (in seconds) of the bookmark to delete.
        public init(
            libraryItemId: String,
            time: Int
        ) {
            self.path = "/api/me/item/\(libraryItemId)/bookmark/\(time)"
        }

    }

    // MARK: Response

    public typealias Response = [AudioBookmark]

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

    ]

}
