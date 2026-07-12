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

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

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
            var items: [URLQueryItem] = [URLQueryItem(name: "q", value: query)]
            items.appendIfPresent("libraryId", libraryId)
            items.appendIfPresent("limit", limit?.description)
            self.queryItems = items
        }
    }

    // MARK: Response

    public enum AudiobookshelfError: Error, Sendable {
    }

    public static let responseCases: ResponseMap = [
        .code(200, .decode)
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
