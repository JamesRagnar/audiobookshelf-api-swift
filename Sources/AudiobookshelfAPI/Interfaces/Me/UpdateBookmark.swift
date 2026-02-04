//
//  UpdateBookmark.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// This endpoint updates an existing bookmark for a library item.
public struct UpdateBookmark: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public typealias Body = Payload

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        /// Update Bookmark Parameters
        ///
        /// - Parameters:
        ///   - libraryItemId: The ID of the library item containing the bookmark.
        ///   - time: The new time (in seconds) for the bookmark.
        ///   - title: The new title of the bookmark.
        public init(
            libraryItemId: String,
            time: Float,
            title: String
        ) {
            self.path = "/api/me/item/\(libraryItemId)/bookmark"
            self.body = Payload(time: time, title: title)
        }

    }

    // MARK: Response

    public typealias Response = AudioBookmark

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

    ]

}

public extension UpdateBookmark.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let time: Float

        let title: String

    }

}
