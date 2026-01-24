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

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data? = nil

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

    public enum AudiobookshelfError: Error {

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        404: .failure(AudiobookshelfError.notFound),

    ]

}
