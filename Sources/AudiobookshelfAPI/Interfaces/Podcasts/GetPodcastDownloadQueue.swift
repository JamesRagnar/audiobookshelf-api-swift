//
//  GetPodcastDownloadQueue.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Get current download queue for a podcast.
public struct GetPodcastDownloadQueue: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// Get Podcast Download Queue Parameters
        ///
        /// - Parameter podcastId: The ID of the podcast library item.
        public init(podcastId: String) {
            self.path = "/api/podcasts/\(podcastId)/downloads"
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        /// The queued downloads for this podcast. Does not include an in-progress download.
        public let downloads: [PodcastEpisodeDownload]

    }

    public enum AudiobookshelfError: Error, Sendable {

        /// You do not have access to this library item.
        case forbidden

        case notFound

        /// The library item could not be loaded.
        case internalServerError

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound)),
        .code(500, .error(AudiobookshelfError.internalServerError))
    ]

}
