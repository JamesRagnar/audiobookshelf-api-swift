//
//  CloseFeed.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Close an RSS feed.
public struct CloseFeed: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Close Feed Parameters
        ///
        /// - Parameters:
        ///   - feedId: The ID of the feed to close.
        public init(feedId: String) {
            self.path = "/api/feeds/\(feedId)/close"
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case notFound

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(404, .error(AudiobookshelfError.notFound)),
    ]

}
