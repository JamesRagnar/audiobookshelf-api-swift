//
//  RemoveLibraryNarrator.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Remove a narrator from a library.
///
/// Requires Audiobookshelf v2.36.1 or later for library-scoped behavior. Older supported servers may
/// update matching books in other libraries. Gate this mutation by the full server version or avoid it.
public struct RemoveLibraryNarrator: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Remove Library Narrator Request
        ///
        /// - Parameters:
        ///   - libraryId: The ID of the library.
        ///   - narratorName: The narrator name to remove.
        /// - Important: Requires Audiobookshelf v2.36.1 or later for library-scoped behavior. Older supported
        ///   servers may mutate matching narrators in other libraries.
        public init(libraryId: String, narratorName: String) {
            let encodedNarrator = Base64URL.encode(narratorName)
            self.path = "/api/libraries/\(libraryId)/narrators/\(encodedNarrator)"
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        public let updated: Int

    }

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

        /// The `limit` or `page` query parameter was not a non-negative integer.
        case badRequest

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
