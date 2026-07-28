//
//  GetAllMediaProgress.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-07-27.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves every media progress entry on your user.
///
/// The same entries are included on the `GetYourUser` response. This endpoint exists to fetch them
/// without the rest of the user payload.
///
/// - Note: Requires server `>= 2.36.0`.
public struct GetAllMediaProgress: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/api/me/progress"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// Get All Media Progress Parameters
        public init() {}

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        /// Every media progress entry on your user. Empty if there are none.
        public let mediaProgress: [MediaProgress]

    }

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .decode)
    ]

}
