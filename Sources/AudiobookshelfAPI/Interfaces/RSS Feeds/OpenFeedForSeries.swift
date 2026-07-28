//
//  OpenFeedForSeries.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Open an RSS feed for a series.
public struct OpenFeedForSeries: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationType = .bearer

        /// Open Feed For Series Parameters
        ///
        /// - Parameters:
        ///   - seriesId: The ID of the series.
        ///   - serverAddress: The server address for the RSS feed.
        ///   - slug: The slug for the RSS feed URL.
        ///   - preventIndexing: Whether to prevent search engine indexing.
        ///   - ownerName: Optional owner name for the feed.
        ///   - ownerEmail: Optional owner email for the feed.
        public init(
            seriesId: String,
            serverAddress: String,
            slug: String,
            preventIndexing: Bool? = nil,
            ownerName: String? = nil,
            ownerEmail: String? = nil
        ) {
            self.path = "/api/feeds/series/\(seriesId)/open"
            self.body = Payload(
                serverAddress: serverAddress,
                slug: slug,
                metadataDetails: MetadataDetails(
                    preventIndexing: preventIndexing,
                    ownerName: ownerName,
                    ownerEmail: ownerEmail
                )
            )
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let feed: RSSFeed

    }

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case notFound

        case internalError

        /// Only admins may manage RSS feeds.
        case forbidden

    }

    public static let responseCases: ResponseMap = [
        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound)),
        .code(500, .error(AudiobookshelfError.internalError))
    ]

}

public extension OpenFeedForSeries.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let serverAddress: String

        let slug: String

        let metadataDetails: MetadataDetails?

    }

    struct MetadataDetails: Encodable, Sendable {

        let preventIndexing: Bool?

        let ownerName: String?

        let ownerEmail: String?

    }

}
