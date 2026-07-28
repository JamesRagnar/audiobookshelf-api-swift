//
//  SearchPodcastEpisode.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2025-01-27.
//

import Foundation
import RagnarNetworking

/// Search for a podcast episode by title.
public struct SearchPodcastEpisode: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// Search Podcast Episode Parameters
        ///
        /// - Parameters:
        ///   - podcastId: The ID of the podcast library item.
        ///   - title: The episode title to search for.
        public init(podcastId: String, title: String) {
            self.path = "/api/podcasts/\(podcastId)/search-episode"
            self.queryItems = [URLQueryItem(name: "title", value: title)]
        }
    }

    // MARK: Response

    public struct Response: Decodable, Sendable {
        public let episode: PodcastEpisode?
    }

    public enum AudiobookshelfError: Error, Sendable {
        case badRequest
        case notFound
        /// You do not have access to this library item, or you lack the required permission.
        case forbidden

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
