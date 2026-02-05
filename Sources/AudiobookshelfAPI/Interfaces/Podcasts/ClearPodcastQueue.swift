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

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil


        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Clear Podcast Queue Parameters
        ///
        /// - Parameters:
        ///   - podcastId: The ID of the podcast library item.
        public init(podcastId: String) {
            self.path = "/api/podcasts/\(podcastId)/clear-queue"
        }
    }

    // MARK: Response

    public typealias Response = Data

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
