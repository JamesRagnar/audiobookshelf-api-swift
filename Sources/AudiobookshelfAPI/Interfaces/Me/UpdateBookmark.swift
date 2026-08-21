//
//  UpdateBookmark.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// This endpoint updates the title of an existing bookmark for a library item.
///
/// The server uses `libraryItemId` and `time` to find the existing bookmark.
/// The PATCH operation changes only `title`; `time` is not a new bookmark position.
/// Requests must include both `time` and `title`, and the server returns 404 when no
/// bookmark exists at the supplied time. A different time does not move a bookmark.
public struct UpdateBookmark: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Update Bookmark Request
        ///
        /// - Parameters:
        ///   - libraryItemId: The ID of the library item containing the bookmark.
        ///   - time: The existing bookmark time (in seconds) used to find the bookmark.
        ///   - title: The new title of the bookmark.
        public init(
            libraryItemId: String,
            time: Double,
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

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}

public extension UpdateBookmark.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let time: Double

        let title: String

    }

}
