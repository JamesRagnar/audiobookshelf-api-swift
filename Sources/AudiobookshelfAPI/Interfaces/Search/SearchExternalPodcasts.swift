//
//  SearchExternalPodcasts.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Search for podcasts via iTunes.
public struct SearchExternalPodcasts: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/api/search/podcast"

        public let queryItems: [String: String?]?

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Search External Podcasts Parameters
        ///
        /// - Parameter term: The search term for podcast search.
        public init(term: String) {
            self.queryItems = ["term": term]
        }

    }

    // MARK: Response

    public typealias Response = [ExternalPodcastSearchResult]

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
    ]

}
