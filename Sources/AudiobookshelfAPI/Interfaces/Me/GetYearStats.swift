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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Get Year Stats Request
        ///
        /// - Parameter year: Required year in 2000...9999 (2.26.0+).
        public init(year: Int) {
            self.path = "/api/me/stats/year/\(year)"
        }

    }

    // MARK: Response

    public typealias Response = YearStats

    public enum AudiobookshelfError: Error, Sendable {
        /// Year must be an integer in 2000...9999.
        case badRequest
    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [.code(400, .error(AudiobookshelfError.badRequest))]
    )

}
