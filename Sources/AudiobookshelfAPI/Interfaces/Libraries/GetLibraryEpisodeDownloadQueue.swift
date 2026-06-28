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

        public let queryItems: [String: String?]? = nil

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

    public typealias Response = [PodcastEpisodeDownload]

    public enum AudiobookshelfError: Error, Sendable {

        case notFound

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}
