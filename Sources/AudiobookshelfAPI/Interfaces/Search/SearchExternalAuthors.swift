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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String = "/api/search/authors"

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Search External Authors Request
        ///
        /// - Parameter query: The author name to search for.
        public init(query: String) {
            self.queryItems = [URLQueryItem(name: "q", value: query)]
        }

    }

    // MARK: Response

    /// The single best-matching author, or null when no author matched closely enough.
    public typealias Response = ExternalAuthorSearchResult?

    public enum AudiobookshelfError: Error, Sendable {

        /// The lookup against the external provider failed.
        /// The `q` query parameter was missing or empty.
        case badRequest

        case internalServerError

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(500, .error(AudiobookshelfError.internalServerError))
        ]
    )

}
