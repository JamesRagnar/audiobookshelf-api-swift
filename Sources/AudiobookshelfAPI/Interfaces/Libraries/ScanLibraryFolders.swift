//
//  ScanLibraryFolders.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-22.
//

import Foundation
import RagnarNetworking

/// This endpoint starts a scan of a library's folders for new library items and changes to existing library items.
public struct ScanLibraryFolders: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Scan Library Folders Request
        ///
        /// - Parameters:
        ///   - libraryID: The ID of the library.
        ///   - force: Whether to force a rescan for all of a library's items. 0 for false, 1 for true.
        public init(
            libraryID: String,
            force: Bool? = nil
        ) {
            self.path = "/api/libraries/\(libraryID)/scan"

            var queryItems: [URLQueryItem] = []
            queryItems.appendIfPresent("force", force?.binaryString)
            self.queryItems = queryItems
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

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
            /// An admin user is required to start a scan.
            .code(403, .error(AudiobookshelfError.forbidden)),
            /// The user cannot access the library, or no library with the provided ID exists.
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}
