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

        public let queryItems: [String : String?]?

        public let headers: [String : String]? = nil

        public typealias Body = EmptyBody

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Search Podcast Episode Parameters
        ///
        /// - Parameters:
        ///   - podcastId: The ID of the podcast library item.
        ///   - title: The episode title to search for.
        public init(podcastId: String, title: String) {
            self.path = "/api/podcasts/\(podcastId)/search-episode"
            self.queryItems = ["title": title]
        }
    }

    // MARK: Response

    public struct Response: Decodable, Sendable {
        public let episode: PodcastEpisode?
    }

    public enum AudiobookshelfError: Error {
        case badRequest
        case notFound
    }

    public static let responseCases: ResponseCases = [
        200: .success(Response.self),
        400: .failure(AudiobookshelfError.badRequest),
        404: .failure(AudiobookshelfError.notFound)
    ]
}
