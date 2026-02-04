//
//  UpdateServerSettings.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Update server settings.
public struct UpdateServerSettings: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String = "/api/settings"

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]?

        public let body: RequestBody?

        public let authentication: AuthenticationType = .bearer

        /// Update Server Settings Parameters
        ///
        /// All parameters are optional - only include fields you want to update.
        public init(settings: [String: Any]) throws {
            self.headers = ["Content-Type": "application/json"]
            let jsonData = try JSONSerialization.data(withJSONObject: settings)
            self.body = .data(jsonData)
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

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
