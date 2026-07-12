//
//  GetSeriesById.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-21.
//

import Foundation
import RagnarNetworking

/// Get a single series by ID.
public struct GetSeriesById: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public enum Include: String {

            case progress

            case rssFeed

        }

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// Get Series by ID Parameters
        ///
        /// - Parameters:
        ///   - seriesID: The ID of the series.
        ///   - include: Optional includes (progress, rssfeed).
        public init(
            seriesID: String,
            include: Set<Include>? = nil
        ) {
            path = "/api/series/\(seriesID)"

            var queryItems: [URLQueryItem] = []
            queryItems.appendIfPresent("include", include?.joined())
            self.queryItems = queryItems
        }

    }

    // MARK: Response

    public typealias Response = Series

    public enum AudiobookshelfError: Error, Sendable {

        case notFound

    }

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .decode),
        /// No series with provided ID exists.
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}
