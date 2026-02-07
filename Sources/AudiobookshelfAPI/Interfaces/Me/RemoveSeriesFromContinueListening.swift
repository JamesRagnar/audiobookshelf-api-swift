//
//  RemoveSeriesFromContinueListening.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// This endpoint removes a series from the "Continue Listening" shelf.
public struct RemoveSeriesFromContinueListening: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Remove Series From Continue Listening Parameters
        ///
        /// - Parameter seriesId: The ID of the series to remove from continue listening.
        public init(seriesId: String) {
            self.path = "/api/me/series/\(seriesId)/remove-from-continue-listening"
        }

    }

    // MARK: Response

    public typealias Response = String

    public static let responseCases: ResponseMap = [

        .code(200, .decode)
    ]

}
