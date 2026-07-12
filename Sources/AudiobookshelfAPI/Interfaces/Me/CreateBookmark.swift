//
//  CreateBookmark.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// This endpoint creates a bookmark for a library item at a specific time.
public struct CreateBookmark: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationType = .bearer

        /// Create Bookmark Parameters
        ///
        /// - Parameters:
        ///   - libraryItemId: The ID of the library item to create a bookmark for.
        ///   - time: The time (in seconds) to create the bookmark at.
        ///   - title: The title of the bookmark.
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

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}

public extension CreateBookmark.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let time: Float

        let title: String

    }

}
