//
//  ParseOPML.swift
//  AudiobookshelfAPI
//
//  Created by Ragnar Henriksen on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Parse an OPML file to extract RSS feed URLs.
public struct ParseOPML: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/podcasts/opml/parse"

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        /// Parse OPML Parameters
        ///
        /// - Parameters:
        ///   - opmlText: The OPML XML content as a string.
        public init(opmlText: String) throws {
            self.body = try JSONEncoder().encode(Body(opmlText: opmlText))
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let feeds: [OPMLFeed]

    }

    public enum AudiobookshelfError: Error {

        case badRequest

        case forbidden

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        403: .failure(AudiobookshelfError.forbidden)

    ]

}

extension ParseOPML.Parameters {

    struct Body: Encodable {

        let opmlText: String

    }

}

public extension ParseOPML {

    struct OPMLFeed: Decodable, Sendable {

        public let title: String

        public let feedUrl: String

    }

}
