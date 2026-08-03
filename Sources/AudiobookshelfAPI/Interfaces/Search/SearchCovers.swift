//
//  SearchCovers.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2025-01-27.
//

import Foundation
import RagnarNetworking

/// Search for cover images from metadata providers.
public struct SearchCovers: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String = "/api/search/covers"

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Search Covers Request
        ///
        /// - Parameters:
        ///   - query: The search query (title and/or author).
        ///   - provider: The metadata provider to search.
        ///   - asin: ASIN for Audible searches (optional).
        public init(
            query: String,
            provider: String,
            asin: String? = nil
        ) {
            var items: [URLQueryItem] = [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "provider", value: provider)
            ]
            items.appendIfPresent("asin", asin)
            self.queryItems = items
        }
    }

    // MARK: Response

    public enum AudiobookshelfError: Error, Sendable {
        case badRequest
        case internalError
    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(500, .error(AudiobookshelfError.internalError))
        ]
    )
}

public extension SearchCovers {

    struct Response: Decodable, Sendable, InterfaceResponse {

        public let results: [CoverResult]

    }

    struct CoverResult: Decodable, Sendable {

        public let title: String

        public let author: String?

        public let cover: String

    }

}
