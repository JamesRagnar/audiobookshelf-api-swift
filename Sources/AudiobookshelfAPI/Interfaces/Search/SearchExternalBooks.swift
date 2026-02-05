//
//  SearchExternalBooks.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Search for books via external providers.
public struct SearchExternalBooks: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/api/search/books"

        public let queryItems: [String : String?]?

        public let headers: [String : String]? = nil


        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Search External Books Parameters
        ///
        /// - Parameters:
        ///   - title: The book title to search for.
        ///   - author: The author name to search for.
        ///   - provider: The search provider (audible, google, itunes, openlibrary).
        public init(
            title: String? = nil,
            author: String? = nil,
            provider: String? = nil
        ) {
            var items: [String: String] = [:]
            if let title = title {
                items["title"] = title
            }
            if let author = author {
                items["author"] = author
            }
            if let provider = provider {
                items["provider"] = provider
            }
            self.queryItems = items.isEmpty ? nil : items
        }

    }

    // MARK: Response

    public typealias Response = [ExternalBookSearchResult]

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

    ]

}
