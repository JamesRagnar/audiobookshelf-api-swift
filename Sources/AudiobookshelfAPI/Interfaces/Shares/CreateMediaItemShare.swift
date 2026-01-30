//
//  CreateMediaItemShare.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Create a public share for a media item.
public struct CreateMediaItemShare: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/share/mediaitem"

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        /// Create Media Item Share Parameters
        ///
        /// - Parameters:
        ///   - slug: Unique identifier for the share URL.
        ///   - mediaItemType: Type of media ('book' or 'podcastEpisode').
        ///   - mediaItemId: ID of the media item to share.
        ///   - expiresAt: Optional expiration timestamp (milliseconds since epoch).
        ///   - isDownloadable: Whether the share allows downloads.
        public init(
            slug: String,
            mediaItemType: String,
            mediaItemId: String,
            expiresAt: Int? = nil,
            isDownloadable: Bool = false
        ) throws {
            self.body = try JSONEncoder().encode(
                Body(
                    slug: slug,
                    mediaItemType: mediaItemType,
                    mediaItemId: mediaItemId,
                    expiresAt: expiresAt,
                    isDownloadable: isDownloadable
                )
            )
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let id: String

        public let mediaItemId: String

        public let mediaItemType: String

        public let slug: String

        public let expiresAt: Date?

        public let createdAt: Date

        public let updatedAt: Date

        public let isDownloadable: Bool

    }

    public enum AudiobookshelfError: Error {

        case badRequest

        case forbidden

        case notFound

        case conflict

        case internalError

    }

    public static let responseCases: ResponseCases = [

        201: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        403: .failure(AudiobookshelfError.forbidden),

        404: .failure(AudiobookshelfError.notFound),

        409: .failure(AudiobookshelfError.conflict),

        500: .failure(AudiobookshelfError.internalError)

    ]

}

public extension CreateMediaItemShare.Parameters {

    struct Body: Encodable {

        let slug: String

        let mediaItemType: String

        let mediaItemId: String

        let expiresAt: Int?

        let isDownloadable: Bool

    }

}
