//
//  GetAllFeeds.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Get all RSS feeds.
public struct GetAllFeeds: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/api/feeds"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        public init() {}

    }

    // MARK: Response

    public typealias Response = RSSFeedListResponse

    public static let responseCases: ResponseMap = [

        .code(200, .decode)
    ]

}

public extension GetAllFeeds {

    struct RSSFeedListResponse: Decodable, Sendable {

        public let feeds: [RSSFeed]

        public let minified: [RSSFeed]

    }

}
