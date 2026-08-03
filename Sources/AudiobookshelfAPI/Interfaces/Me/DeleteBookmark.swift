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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Delete Bookmark Request
        ///
        /// - Parameters:
        ///   - libraryItemId: The ID of the library item containing the bookmark.
        ///   - time: The time (in seconds) of the bookmark to delete.
        public init(
            libraryItemId: String,
            time: Double
        ) {
            self.path = "/api/me/item/\(libraryItemId)/bookmark/\(time)"
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

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
