//
//  GetLibraryAuthors.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation
import RagnarNetworking

/// This endpoint returns a library's authors.
public struct GetLibraryAuthors: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Get Library Authors Request
        ///
        /// - Parameter libraryID: The ID of the library.
        public init(
            libraryID: String
        ) {
            self.path = "/api/libraries/\(libraryID)/authors"
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        public let authors: [Author]

    }

    public enum AudiobookshelfError: Error, Sendable {

        /// The `limit` or `page` query parameter was not a non-negative integer.
        case badRequest

        /// You do not have access to this library.
        case forbidden

        /// No library exists with the given ID.
        case notFound

    }

    public static let responses = ResponseContract<Response>(
        /// The requested authors.
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}
