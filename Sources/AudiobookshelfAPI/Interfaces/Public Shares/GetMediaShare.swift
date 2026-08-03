//
//  GetMediaShare.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Get a publicly shared media item by slug.
public struct GetMediaShare: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = nil

        /// Get Media Share Request
        ///
        /// - Parameters:
        ///   - slug: The unique share identifier.
        ///   - startTime: Optional start time in seconds.
        public init(
            slug: String,
            startTime: Int? = nil
        ) {
            self.path = "/public/share/\(slug)"

            var queryItems: [URLQueryItem] = []
            queryItems.appendIfPresent("t", startTime?.description)
            self.queryItems = queryItems.isEmpty ? nil : queryItems
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        public let id: String

        public let mediaItemId: String

        public let mediaItemType: String

        public let slug: String

        public let expiresAt: Date?

        public let createdAt: Date

        public let updatedAt: Date

        public let isDownloadable: Bool

        public let playbackSession: PlaybackSession

    }

    public enum AudiobookshelfError: Error, Sendable {

        case notFound

        case internalError

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(404, .error(AudiobookshelfError.notFound)),
            .code(500, .error(AudiobookshelfError.internalError))
        ]
    )

}
