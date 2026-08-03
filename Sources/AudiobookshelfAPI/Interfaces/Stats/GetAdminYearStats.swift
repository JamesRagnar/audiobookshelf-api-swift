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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Get Admin Year Stats Request
        ///
        /// - Parameter year: The year to get admin statistics for.
        public init(year: Int) {
            self.path = "/api/stats/year/\(year)"
        }

    }

    // MARK: Response

    public typealias Response = YearStats

    public enum AudiobookshelfError: Error, Sendable {

        /// Only admins may read server statistics.
        case forbidden

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(403, .error(AudiobookshelfError.forbidden))
        ]
    )

}
