//
//  ParseOPML.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Parse an OPML file to extract RSS feed URLs.
public struct ParseOPML: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/podcasts/opml/parse"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        /// Parse OPML Parameters
        ///
        /// - Parameters:
        ///   - opmlText: The OPML XML content as a string.
        public init(opmlText: String) {
            self.body = Payload(opmlText: opmlText)
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let feeds: [OPMLFeed]

    }

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden))
    ]

}

public extension ParseOPML.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let opmlText: String

    }

}

public extension ParseOPML {

    struct OPMLFeed: Decodable, Sendable {

        public let title: String

        public let feedUrl: String

    }

}
