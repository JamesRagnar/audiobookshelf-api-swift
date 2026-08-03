//
//  GetPodcastEpisode.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-17.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves a podcast episode.
public struct GetPodcastEpisode: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        public init(
            libraryItemID: String,
            episodeID: String
        ) {
            self.path = "/api/podcasts/\(libraryItemID)/episode/\(episodeID)"
        }

    }

    // MARK: Response

    public typealias Response = PodcastEpisode

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

        case internalServerError

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            /// The user is not allowed to access the library item.
            .code(403, .error(AudiobookshelfError.forbidden)),
            /// No podcast episode with the given ID exists.
            .code(404, .error(AudiobookshelfError.notFound)),
            /// The library item is not a podcast.
            .code(500, .error(AudiobookshelfError.internalServerError))
        ]
    )

}
