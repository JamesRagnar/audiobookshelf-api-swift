//
//  OpenFeedForItem.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Open an RSS feed for a library item.
public struct OpenFeedForItem: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        /// Open Feed For Item Parameters
        ///
        /// - Parameters:
        ///   - itemId: The ID of the library item.
        ///   - serverAddress: The server address for the RSS feed.
        ///   - slug: The slug for the RSS feed URL.
        ///   - preventIndexing: Whether to prevent search engine indexing.
        ///   - ownerName: Optional owner name for the feed.
        ///   - ownerEmail: Optional owner email for the feed.
        public init(
            itemId: String,
            serverAddress: String,
            slug: String,
            preventIndexing: Bool? = nil,
            ownerName: String? = nil,
            ownerEmail: String? = nil
        ) throws {
            self.path = "/api/feeds/item/\(itemId)/open"
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

        public let feed: RSSFeed

    }

    public enum AudiobookshelfError: Error {

        case badRequest

        case forbidden

        case notFound

        case internalError

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        403: .failure(AudiobookshelfError.forbidden),

        404: .failure(AudiobookshelfError.notFound),

        500: .failure(AudiobookshelfError.internalError)

    ]

}

extension OpenFeedForItem.Parameters {

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
