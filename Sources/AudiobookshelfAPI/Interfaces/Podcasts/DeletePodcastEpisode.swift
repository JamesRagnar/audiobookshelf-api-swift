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

        public let queryItems: [String : String]?

        public let headers: [String : String]? = nil

        public let body: Data? = nil

        public let authentication: AuthenticationType = .bearer

        /// Delete Podcast Episode Parameters
        ///
        /// - Parameters:
        ///   - podcastId: The ID of the podcast library item.
        ///   - episodeId: The ID of the episode to delete.
        ///   - hardDelete: If true, deletes the audio file from filesystem (optional).
        public init(
            podcastId: String,
            episodeId: String,
            hardDelete: Bool? = nil
        ) {
            self.path = "/api/podcasts/\(podcastId)/episode/\(episodeId)"

            if let hardDelete = hardDelete {
                self.queryItems = ["hard": hardDelete ? "1" : "0"]
            } else {
                self.queryItems = nil
            }
        }

    }

    // MARK: Response

    public typealias Response = Data

    public enum AudiobookshelfError: Error {
        case badRequest
        case forbidden
        case notFound
    }

    public static let responseCases: ResponseCases = [
        200: .success(Response.self),
        400: .failure(AudiobookshelfError.badRequest),
        403: .failure(AudiobookshelfError.forbidden),
        404: .failure(AudiobookshelfError.notFound)
    ]

}
