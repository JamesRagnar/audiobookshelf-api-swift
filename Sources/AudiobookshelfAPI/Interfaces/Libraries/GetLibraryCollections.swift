//
//  GetLibraryCollections.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-22.
//

import Foundation
import RagnarNetworking

/// This endpoint returns a library's collections.
public struct GetLibraryCollections: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public enum Include: String {

            case rssfeed

        }

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// Get Library Collection Parameters
        ///
        /// - Note: Sorting and filtering are not yet implemented.
        ///
        /// - Parameters:
        ///   - libraryID: The ID of the library.
        ///   - limit: Limit the number of returned results per page. If 0, no limit will be applied.
        /// - page: The page number (0 indexed) to request. If there is no limit applied, then page will have no effect
        /// and all results will be returned.
        ///   - sort: What to sort the results by.
        ///   - descending: Whether to reverse the sort order.
        ///   - filter: What to filter the results by.
        ///   - minified: Whether to request minified objects.
        ///   - include: A comma separated list of what to include with the library items.
        public init(
            libraryID: String,
            limit: Int? = nil,
            page: Int? = nil,
            sort: String? = nil,
            descending: Bool? = nil,
            filter: String? = nil,
            minified: Bool? = nil,
            include: Set<Include>? = nil
        ) {
            self.path = "/api/libraries/\(libraryID)/collections"

            var queryItems: [URLQueryItem] = []
            queryItems.appendIfPresent("limit", limit?.description)
            queryItems.appendIfPresent("page", page?.description)
            queryItems.appendIfPresent("sort", sort)
            queryItems.appendIfPresent("desc", descending?.binaryString)
            queryItems.appendIfPresent("filter", filter)
            queryItems.appendIfPresent("minified", minified?.binaryString)
            queryItems.appendIfPresent("include", include?.joined())
            self.queryItems = queryItems
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        /// The requested collections.
        /// If minified is true, the library items contained in the collections will be Library Item Minified.
        /// If rssfeed was requested, an RSS Feed Minified object or null as rssFeed, the collection's RSS feed if it
        /// has one open, will be added to the collections.
        public let results: [Collection]

        /// The total number of results.
        public let total: Int

        /// The limit set in the request.
        public let limit: Int

        /// The page set in request.
        public let page: Int

        /// The sort set in the request. Will not exist if no sort was set.
        public let sortBy: String?

        /// Whether to reverse the sort order.
        public let sortDesc: Bool

        /// The filter set in the request, URL decoded. Will not exist if no filter was set.
        public let filterBy: String?

        /// Whether minified was set in the request.
        public let minified: Bool

        /// The requested include.
        public let include: String

    }

    public enum AudiobookshelfError: Error, Sendable {

        case notFound

        /// The `limit` or `page` query parameter was not a non-negative integer.
        case badRequest

        /// You do not have access to this library.
        case forbidden

    }

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden)),
        /// The user cannot access the library, or no library with the provided ID exists.
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}
