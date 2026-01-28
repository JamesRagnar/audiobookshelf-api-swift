//
//  OpenFeedForSeries.swift
//  AudiobookshelfAPI
//
//  Created by Ragnar Henriksen on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Open an RSS feed for a series.
public struct OpenFeedForSeries: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

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
        ) throws {
            self.path = "/api/feeds/series/\(seriesId)/open"
            self.body = try JSONEncoder().encode(
                Body(
                    serverAddress: serverAddress,
                    slug: slug,
                    metadataDetails: MetadataDetails(
                        preventIndexing: preventIndexing,
                        ownerName: ownerName,
                        ownerEmail: ownerEmail
                    )
                )
            )
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let feed: Feed

    }

    public enum AudiobookshelfError: Error {

        case badRequest

        case notFound

        case internalError

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        404: .failure(AudiobookshelfError.notFound),

        500: .failure(AudiobookshelfError.internalError)

    ]

}

extension OpenFeedForSeries.Parameters {

    struct Body: Encodable {

        let serverAddress: String

        let slug: String

        let metadataDetails: MetadataDetails?

    }

    struct MetadataDetails: Encodable {

        let preventIndexing: Bool?

        let ownerName: String?

        let ownerEmail: String?

    }

}
