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

        public enum Sort: String, CaseIterable, Sendable {

            case name

            case lastFirst

            case addedAt

            case updatedAt

            case numBooks

        }

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Get Library Authors Request
        ///
        /// - Parameters:
        ///   - libraryID: The ID of the library.
        ///   - limit: The number of authors to return per page. If supplied without a page, page 0 is requested.
        ///   - page: The page number (0 indexed) to request when a limit is supplied.
        ///   - sort: The field to sort authors by. Defaults to name.
        ///   - descending: Whether to reverse the sort order. Defaults to ascending.
        public init(
            libraryID: String,
            limit: Int? = nil,
            page: Int? = nil,
            sort: Sort = .name,
            descending: Bool = false
        ) {
            self.path = "/api/libraries/\(libraryID)/authors"

            var queryItems: [URLQueryItem] = []
            queryItems.appendIfPresent("limit", limit?.description)
            let resolvedPage = limit == nil ? page : page ?? 0
            queryItems.appendIfPresent("page", resolvedPage?.description)
            queryItems.appendIfPresent("sort", sort.rawValue)
            queryItems.appendIfPresent("desc", descending.binaryString)
            self.queryItems = queryItems
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        public let authors: [Author]

        /// The total number of matching authors when pagination is requested.
        public let total: Int?

        /// The page size when pagination is requested.
        public let limit: Int?

        /// The page number when pagination is requested.
        public let page: Int?

        /// The sort field returned by the server.
        public let sortBy: String?

        /// Whether the server returned descending results.
        public let sortDesc: Bool?

        private enum CodingKeys: String, CodingKey {

            case authors
            case results
            case total
            case limit
            case page
            case sortBy
            case sortDesc

        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let authors = try container.decodeIfPresent([Author].self, forKey: .authors) {
                self.authors = authors
            } else {
                self.authors = try container.decode([Author].self, forKey: .results)
            }
            self.total = try container.decodeIfPresent(Int.self, forKey: .total)
            self.limit = try container.decodeIfPresent(Int.self, forKey: .limit)
            self.page = try container.decodeIfPresent(Int.self, forKey: .page)
            self.sortBy = try container.decodeIfPresent(String.self, forKey: .sortBy)
            self.sortDesc = try container.decodeIfPresent(Bool.self, forKey: .sortDesc)
        }

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
