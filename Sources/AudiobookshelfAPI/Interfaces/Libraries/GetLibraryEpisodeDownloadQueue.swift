//
//  GetLibraryEpisodeDownloadQueue.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Get episode download queue for a library.
public struct GetLibraryEpisodeDownloadQueue: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// Get Library Episode Download Queue Parameters
        ///
        /// - Parameter libraryId: The ID of the library.
        public init(libraryId: String) {
            self.path = "/api/libraries/\(libraryId)/episode-downloads"
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        /// The episode currently downloading. Null when nothing in this library is downloading.
        public let currentDownload: PodcastEpisodeDownload?

        /// The episodes queued behind the current download.
        public let queue: [PodcastEpisodeDownload]

    }

    public enum AudiobookshelfError: Error, Sendable {

        /// The `limit` or `page` query parameter was not a non-negative integer.
        case badRequest

        /// You do not have access to this library.
        case forbidden

        case notFound

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}
