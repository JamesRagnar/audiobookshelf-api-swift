//
//  GetYearStats.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Get yearly listening statistics for the authenticated user.
public struct GetYearStats: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// Get Year Stats Parameters
        ///
        /// - Parameter year: The year to get statistics for.
        public init(year: Int) {
            self.path = "/api/me/stats/year/\(year)"
        }

    }

    // MARK: Response

    public typealias Response = YearStats

    public static let responseCases: ResponseMap = [

        .code(200, .decode)
    ]

}
