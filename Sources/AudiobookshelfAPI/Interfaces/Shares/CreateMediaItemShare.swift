//
//  CreateMediaItemShare.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Create a public share record for a book or podcastEpisode on 2.26.0+.
/// Public playback lookup currently resolves only books.
public struct CreateMediaItemShare: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String = "/api/share/mediaitem"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Create Media Item Share Request
        ///
        /// - Parameters:
        ///   - slug: Unique identifier for the share URL.
        ///   - mediaItemType: Type of media ('book' or 'podcastEpisode').
        ///   - mediaItemId: ID of the media item to share.
        ///   - expiresAt: Wire expiresAt in epoch milliseconds; nil encodes 0 for permanent.
        ///     Negative values are invalid.
        ///   - isDownloadable: Whether the share allows downloads.
        public init(
            slug: String,
            mediaItemType: String,
            mediaItemId: String,
            expiresAt: Int? = nil,
            isDownloadable: Bool = false
        ) {
            self.body = Payload(
                slug: slug,
                mediaItemType: mediaItemType,
                mediaItemId: mediaItemId,
                expiresAt: expiresAt ?? 0,
                isDownloadable: isDownloadable
            )
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        public let id: String

        public let mediaItemId: String

        public let mediaItemType: String

        public let slug: String

        /// Optional wire expiresAt, ISO-8601 date (2.26.0+); missing/null means permanent.
        public let expiresAt: Date?

        /// Required wire createdAt, ISO-8601 date (2.26.0+).
        public let createdAt: Date

        /// Required wire updatedAt, ISO-8601 date (2.26.0+).
        public let updatedAt: Date

        public let isDownloadable: Bool

        private enum CodingKeys: CodingKey {
            case id
            case mediaItemId
            case mediaItemType
            case slug
            case expiresAt
            case createdAt
            case updatedAt
            case isDownloadable
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(String.self, forKey: .id)
            mediaItemId = try container.decode(String.self, forKey: .mediaItemId)
            mediaItemType = try container.decode(String.self, forKey: .mediaItemType)
            slug = try container.decode(String.self, forKey: .slug)
            expiresAt = try container.decodeISODateIfPresent(forKey: .expiresAt)
            createdAt = try container.decodeISODate(forKey: .createdAt)
            updatedAt = try container.decodeISODate(forKey: .updatedAt)
            isDownloadable = try container.decode(Bool.self, forKey: .isDownloadable)
        }

    }

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

        case notFound

        case conflict

        case internalError

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(201),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound)),
            .code(409, .error(AudiobookshelfError.conflict)),
            .code(500, .error(AudiobookshelfError.internalError))
        ]
    )

}

public extension CreateMediaItemShare.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let slug: String

        let mediaItemType: String

        let mediaItemId: String

        let expiresAt: Int

        let isDownloadable: Bool

    }

}
