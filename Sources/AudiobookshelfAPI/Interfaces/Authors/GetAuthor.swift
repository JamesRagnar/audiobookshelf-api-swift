//
//  GetAuthor.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-21.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves an author.
public struct GetAuthor: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public enum Include: String {

            case items

            case series

        }

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// Get Author Parameters
        ///
        /// - Parameters:
        ///   - authorID: The ID of the author.
        /// - include: A comma separated list of what to include with the author. The options are items and series.
        /// series will only have an effect if items are included.
        ///   - libraryID: The ID of the library to filter included items from.
        public init(
            authorID: String,
            include: Set<Include>? = nil,
            libraryID: String? = nil
        ) {
            self.path = "/api/authors/\(authorID)"

            var queryItems: [URLQueryItem] = []
            queryItems.appendIfPresent("include", include?.joined())
            queryItems.appendIfPresent("library", libraryID)
            self.queryItems = queryItems
        }

    }

    // MARK: Response

    public typealias Response = Author

    public enum AudiobookshelfError: Error, Sendable {

        case notFound

    }

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .decode),
        /// No author with provided ID exists.
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}
