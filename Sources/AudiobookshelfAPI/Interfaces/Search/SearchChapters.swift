//
//  SearchChapters.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2025-01-27.
//

import Foundation
import RagnarNetworking

/// Search for chapters across library items.
public struct SearchChapters: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/api/search/chapters"

        public let queryItems: [String : String?]?

        public let headers: [String : String]? = nil

        public let body: RequestBody? = nil

        public let authentication: AuthenticationType = .bearer

        /// Search Chapters Parameters
        ///
        /// - Parameters:
        ///   - query: The search query.
        ///   - libraryId: Limit search to specific library (optional).
        ///   - limit: Maximum number of results (optional).
        public init(
            query: String,
            libraryId: String? = nil,
            limit: Int? = nil
        ) {
            var items: [String: String] = ["q": query]

            if let libraryId = libraryId {
                items["libraryId"] = libraryId
            }

            if let limit = limit {
                items["limit"] = String(limit)
            }

            self.queryItems = items
        }
    }

    // MARK: Response

    public enum AudiobookshelfError: Error {
    }

    public static let responseCases: ResponseCases = [
        200: .success(Response.self)
    ]
}

public extension SearchChapters {

    struct Response: Decodable, Sendable {

        public let results: [ChapterResult]

    }

    struct ChapterResult: Decodable, Sendable {

        public let libraryItem: LibraryItem

        public let matchKey: String

        public let matchText: String

    }

}
