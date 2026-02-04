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

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

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
                q: query,
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

    public enum AudiobookshelfError: Error {
        case forbidden
        case notFound
    }

    public static let responseCases: ResponseCases = [
        200: .success(Response.self),
        403: .failure(AudiobookshelfError.forbidden),
        404: .failure(AudiobookshelfError.notFound)
    ]
}

public extension MatchAuthor.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {
        let q: String?
        let asin: String?
        let region: String?
    }
}
