//
//  SearchExternalAuthors.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Search for author information.
public struct SearchExternalAuthors: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/api/search/authors"

        public let queryItems: [String : String?]?

        public let headers: [String : String]? = nil

        public typealias Body = EmptyBody

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Search External Authors Parameters
        ///
        /// - Parameter query: The author name to search for.
        public init(query: String) {
            self.queryItems = ["q": query]
        }

    }

    // MARK: Response

    public typealias Response = [ExternalAuthorSearchResult]

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

    ]

}
