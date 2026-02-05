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

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/api/search/covers"

        public let queryItems: [String : String?]?

        public let headers: [String : String]? = nil


        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Search Covers Parameters
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
            var items: [String: String] = [
                "q": query,
                "provider": provider
            ]

            if let asin = asin {
                items["asin"] = asin
            }

            self.queryItems = items
        }
    }

    // MARK: Response

    public enum AudiobookshelfError: Error {
        case badRequest
        case internalError
    }

    public static let responseCases: ResponseCases = [
        200: .success(Response.self),
        400: .failure(AudiobookshelfError.badRequest),
        500: .failure(AudiobookshelfError.internalError)
    ]
}

public extension SearchCovers {

    struct Response: Decodable, Sendable {

        public let results: [CoverResult]

    }

    struct CoverResult: Decodable, Sendable {

        public let title: String

        public let author: String?

        public let cover: String

    }

}
