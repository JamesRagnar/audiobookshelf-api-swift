//
//  MatchAllLibraryItems.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-22.
//

import Foundation
import RagnarNetworking

/// This endpoint matches all items in a library using quick match.
/// Quick match populates empty book details and the cover with the first book result from the library's default
/// metadata provider.
/// Does not overwrite details unless the "Prefer matched metadata" server setting is enabled.
public struct MatchAllLibraryItems: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// Match All Library Items
        ///
        /// - Parameter libraryID: The ID of the library.
        public init(libraryID: String) {
            self.path = "/api/libraries/\(libraryID)/matchall"
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .noContent),
        /// An admin user is required to match library items.
        .code(403, .error(AudiobookshelfError.forbidden)),
        /// The user cannot access the library, or no library with the provided ID exists.
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}
