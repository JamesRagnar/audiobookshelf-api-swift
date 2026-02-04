//
//  UpdateAuthSettings.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Update authentication settings.
/// Note: This endpoint differentiates between omitted fields (no change) and explicit JSON null (clear value).
/// Use `Nullable.null` to send JSON null; use `nil` to omit the field.
public struct UpdateAuthSettings: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String = "/api/auth-settings"

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public typealias Body = AuthSettingsUpdate

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        /// Update Auth Settings Parameters.
        public init(settings: Body) {
            self.body = settings
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
