//
//  ReaddSeriesToContinueListening.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// This endpoint re-adds a series to the "Continue Listening" shelf.
public struct ReaddSeriesToContinueListening: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public typealias Body = EmptyBody

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Readd Series To Continue Listening Parameters
        ///
        /// - Parameter seriesId: The ID of the series to re-add to continue listening.
        public init(seriesId: String) {
            self.path = "/api/me/series/\(seriesId)/readd-to-continue-listening"
        }

    }

    // MARK: Response

    public typealias Response = String

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

    ]

}
