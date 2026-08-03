//
//  SearchLibrary.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation
import RagnarNetworking

/// This endpoint searches a library for the query and returns the results.
public struct SearchLibrary: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Search Library Request
        ///
        /// - Parameters:
        ///   - libraryID: The ID of the library.
        ///   - query: The search query, automatically URL Encoded
        ///   - limit: Limit the number of returned results.
        public init(
            libraryID: String,
            query: String,
            limit: Int? = nil
        ) {
            self.path = "/api/libraries/\(libraryID)/search"

            var queryItems: [URLQueryItem] = [URLQueryItem(name: "q", value: query)]
            queryItems.appendIfPresent("limit", limit?.description)
            self.queryItems = queryItems
        }
    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// The item results of the search. This attribute will be book or podcast depending on the library's media
        /// type.
        public let book: [LibraryItemSearchResult]?

        /// The item results of the search. This attribute will be book or podcast depending on the library's media
        /// type.
        public let podcast: [LibraryItemSearchResult]?

        /// The tag results of the search.
        public let tags: [TagSearchResult]?

        /// The series results of the search.
        public let series: [SeriesSearchResult]?

        /// The author results of the search.
        public let authors: [Author]?

    }

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        /// You do not have access to this library.
        case forbidden

        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            /// No query string.
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden)),
            /// The user cannot access the library, or no library with the provided ID exists.
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}

public extension SearchLibrary.Response {

    struct LibraryItemSearchResult: Decodable, Sendable {

        /// The matched library item.
        public let libraryItem: LibraryItem

        /// What the library item was matched on.
        public let matchKey: String?

        /// The text in the library item that the query matched to.
        public let matchText: String?

    }

    struct SeriesSearchResult: Decodable, Sendable {

        public let series: Series

        public let books: [LibraryItem]

    }

    struct TagSearchResult: Decodable, Sendable {

        /// The tag value (e.g., "Science Fiction")
        public let name: String

        /// Number of items with this tag
        public let numItems: Int

    }

}
