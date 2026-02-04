//
//  GetAdminYearStats.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Get admin-level yearly listening statistics across all users.
public struct GetAdminYearStats: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public typealias Body = EmptyBody

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Get Admin Year Stats Parameters
        ///
        /// - Parameter year: The year to get admin statistics for.
        public init(year: Int) {
            self.path = "/api/stats/year/\(year)"
        }

    }

    // MARK: Response

    public typealias Response = YearStats

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

    ]

}
