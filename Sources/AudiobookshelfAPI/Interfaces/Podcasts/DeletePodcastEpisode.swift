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

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

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

            var queryItems: [URLQueryItem] = []
            queryItems.appendIfPresent("hard", hardDelete.map { $0 ? "1" : "0" })
            self.queryItems = queryItems.isEmpty ? nil : queryItems
        }

    }

    // MARK: Response

    public typealias Response = LibraryItem

    public enum AudiobookshelfError: Error, Sendable {
        case badRequest
        case forbidden
        case notFound
        /// The library item exists but is not a podcast.
        case internalServerError

    }

    public static let responseCases: ResponseMap = [
        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound)),
        .code(500, .error(AudiobookshelfError.internalServerError))
    ]

}
