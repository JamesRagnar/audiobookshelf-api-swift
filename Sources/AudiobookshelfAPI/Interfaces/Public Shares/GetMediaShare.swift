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

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [String : String]?

        public let headers: [String : String]? = nil

        public let body: Data? = nil

        public let authentication: AuthenticationType = .none

        /// Get Media Share Parameters
        ///
        /// - Parameters:
        ///   - slug: The unique share identifier.
        ///   - startTime: Optional start time in seconds.
        public init(
            slug: String,
            startTime: Int? = nil
        ) {
            self.path = "/public/share/\(slug)"

            var queryItems: [String: String] = [:]
            if let startTime = startTime {
                queryItems["t"] = String(startTime)
            }
            self.queryItems = queryItems.isEmpty ? nil : queryItems
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

        public let playbackSession: PlaybackSession

    }

    public enum AudiobookshelfError: Error {

        case notFound

        case internalError

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        404: .failure(AudiobookshelfError.notFound),

        500: .failure(AudiobookshelfError.internalError)

    ]

}
