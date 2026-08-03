//
//  ClearPodcastQueue.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2025-01-27.
//

import Foundation
import RagnarNetworking

/// Clear the podcast episode download queue.
public struct ClearPodcastQueue: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Clear Podcast Queue Request
        ///
        /// - Parameters:
        ///   - podcastId: The ID of the podcast library item.
        public init(podcastId: String) {
            self.path = "/api/podcasts/\(podcastId)/clear-queue"
        }
    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {
        case badRequest
        case notFound
        /// You do not have access to this library item, or you lack the required permission.
        case forbidden

        /// The library item exists but is not a podcast.
        case internalServerError

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound)),
            .code(500, .error(AudiobookshelfError.internalServerError))
        ]
    )
}
