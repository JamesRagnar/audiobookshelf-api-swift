//
//  MatchAuthor.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-27.
//

import Foundation
import RagnarNetworking

/// Match author metadata
public struct MatchAuthor: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        /// Match Author Parameters
        ///
        /// - Parameters:
        ///   - authorId: The ID of the author.
        ///   - query: Author name to search for (optional).
        ///   - asin: ASIN to look up (optional).
        ///   - region: Region code (optional, defaults to 'us').
        public init(
            authorId: String,
            query: String? = nil,
            asin: String? = nil,
            region: String? = nil
        ) {
            self.path = "/api/authors/\(authorId)/match"
            self.body = Payload(
                query: query,
                asin: asin,
                region: region
            )
        }
    }

    // MARK: Response

    public struct Response: Decodable, Sendable {
        public let updated: Bool
        public let author: Author
    }

    public enum AudiobookshelfError: Error, Sendable {
        case forbidden
        case notFound
    }

    public static let responseCases: ResponseMap = [
        .code(200, .decode),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound)),
    ]
}

public extension MatchAuthor.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {
        let query: String?
        let asin: String?
        let region: String?

        private enum CodingKeys: String, CodingKey {
            case query = "q"
            case asin
            case region
        }
    }
}
