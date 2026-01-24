//
//  DeletePodcastEpisode.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Delete a podcast episode.
public struct DeletePodcastEpisode: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data? = nil

        public let authentication: AuthenticationType = .bearer

        /// Delete Podcast Episode Parameters
        ///
        /// - Parameters:
        ///   - podcastId: The ID of the podcast library item.
        ///   - episodeId: The ID of the podcast episode to delete.
        public init(
            podcastId: String,
            episodeId: String
        ) {
            self.path = "/api/podcasts/\(podcastId)/episode/\(episodeId)"
        }

    }

    // MARK: Response

    public typealias Response = Data

    public enum AudiobookshelfError: Error {

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        404: .failure(AudiobookshelfError.notFound),

    ]

}
