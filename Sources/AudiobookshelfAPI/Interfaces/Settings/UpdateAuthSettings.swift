//
//  UpdateAuthSettings.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Update authentication settings.
public struct UpdateAuthSettings: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String = "/api/auth-settings"

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        /// Update Auth Settings Parameters
        ///
        /// All parameters are optional - only include fields you want to update.
        public init(settings: [String: Any]) throws {
            self.body = try JSONSerialization.data(withJSONObject: settings)
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let updated: Bool

        public let serverSettings: ServerSettings

    }

    public enum AudiobookshelfError: Error {

        case badRequest

        case forbidden

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        403: .failure(AudiobookshelfError.forbidden)

    ]

}
