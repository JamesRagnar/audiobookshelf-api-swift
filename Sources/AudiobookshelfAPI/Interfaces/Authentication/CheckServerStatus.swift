//
//  CheckServerStatus.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-20.
//

import Foundation
import RagnarNetworking

/// This endpoint reports the server's initialization status.
public struct CheckServerStatus: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/status"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .none

        /// Check Server Status Parameters
        public init() {}

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        /// The application name (always "audiobookshelf").
        public let app: String

        /// The server's semver version string (e.g. "2.33.0").
        public let serverVersion: String

        /// Whether the server has been initialized.
        public let isInit: Bool

        /// The server's default language.
        public let language: String

        /// Active authentication methods (e.g. ["local"], ["local", "openid"]).
        public let authMethods: [String]

        /// Additional form-level auth configuration supplied by the server.
        /// - Note: Present on server `>= 2.31.0`. Nil on older servers.
        public let authFormData: AuthFormData?

        /// The server's config path. Will only exist if `isInit` is false.
        public let configPath: String?

        /// The server's metadata path. Will only exist if `isInit` is false.
        public let metadataPath: String?

        private enum CodingKeys: String, CodingKey {
            case app
            case serverVersion
            case isInit
            case language
            case authMethods
            case authFormData
            case configPath = "ConfigPath"
            case metadataPath = "MetadataPath"
        }

    }

    // MARK: AuthFormData

    public struct AuthFormData: Decodable, Sendable {

        /// A custom message displayed on the login screen, if set.
        public let authLoginCustomMessage: String?

        /// The label text for the OpenID Connect sign-in button, if OpenID is enabled.
        public let authOpenIDButtonText: String?

        /// Whether the OpenID flow should launch automatically without user interaction.
        public let authOpenIDAutoLaunch: Bool?

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode)
    ]

}
