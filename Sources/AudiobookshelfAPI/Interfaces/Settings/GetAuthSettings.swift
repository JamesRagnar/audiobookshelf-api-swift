//
//  GetAuthSettings.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Get authentication settings.
public struct GetAuthSettings: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String = "/api/auth-settings"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        public init() {}

    }

    // MARK: Response

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(403, .error(AudiobookshelfError.forbidden))
        ]
    )

}

public extension GetAuthSettings {

    struct Response: Decodable, Sendable, InterfaceResponse {

        public let authLoginCustomMessage: String?

        public let authActiveAuthMethods: [String]

        public let authOpenIDIssuerURL: String?

        public let authOpenIDAuthorizationURL: String?

        public let authOpenIDTokenURL: String?

        public let authOpenIDUserInfoURL: String?

        public let authOpenIDJwksURL: String?

        public let authOpenIDLogoutURL: String?

        public let authOpenIDTokenSigningAlgorithm: String

        public let authOpenIDButtonText: String

        public let authOpenIDAutoLaunch: Bool

        public let authOpenIDAutoRegister: Bool

        public let authOpenIDMatchExistingBy: String?

        public let authOpenIDSubfolderForRedirectURLs: String?

        public let authOpenIDClientID: String?

        public let authOpenIDClientSecret: String?

        public let authOpenIDMobileRedirectURIs: [String]?

        public let authOpenIDGroupClaim: String?

        public let authOpenIDAdvancedPermsClaim: String?

        public let authOpenIDSamplePermissions: String

        enum CodingKeys: String, CodingKey {
            case authLoginCustomMessage
            case authActiveAuthMethods
            case authOpenIDIssuerURL
            case authOpenIDAuthorizationURL
            case authOpenIDTokenURL
            case authOpenIDUserInfoURL
            case authOpenIDJwksURL
            case authOpenIDLogoutURL
            case authOpenIDTokenSigningAlgorithm
            case authOpenIDButtonText
            case authOpenIDAutoLaunch
            case authOpenIDAutoRegister
            case authOpenIDMatchExistingBy
            case authOpenIDSubfolderForRedirectURLs
            case authOpenIDClientID
            case authOpenIDClientSecret
            case authOpenIDMobileRedirectURIs
            case authOpenIDGroupClaim
            case authOpenIDAdvancedPermsClaim
            case authOpenIDSamplePermissions
        }

        /// Decodes legacy deployments that omit or return null for the two nonoptional string fields while
        /// preserving the existing public API. Incompatible value types still fail decoding.
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            authLoginCustomMessage = try container.decodeIfPresent(String.self, forKey: .authLoginCustomMessage)
            authActiveAuthMethods = try container.decode([String].self, forKey: .authActiveAuthMethods)
            authOpenIDIssuerURL = try container.decodeIfPresent(String.self, forKey: .authOpenIDIssuerURL)
            authOpenIDAuthorizationURL = try container.decodeIfPresent(String.self, forKey: .authOpenIDAuthorizationURL)
            authOpenIDTokenURL = try container.decodeIfPresent(String.self, forKey: .authOpenIDTokenURL)
            authOpenIDUserInfoURL = try container.decodeIfPresent(String.self, forKey: .authOpenIDUserInfoURL)
            authOpenIDJwksURL = try container.decodeIfPresent(String.self, forKey: .authOpenIDJwksURL)
            authOpenIDLogoutURL = try container.decodeIfPresent(String.self, forKey: .authOpenIDLogoutURL)
            authOpenIDTokenSigningAlgorithm =
                try container.decodeIfPresent(String.self, forKey: .authOpenIDTokenSigningAlgorithm) ?? ""
            authOpenIDButtonText = try container.decodeIfPresent(String.self, forKey: .authOpenIDButtonText) ?? ""
            authOpenIDAutoLaunch = try container.decode(Bool.self, forKey: .authOpenIDAutoLaunch)
            authOpenIDAutoRegister = try container.decode(Bool.self, forKey: .authOpenIDAutoRegister)
            authOpenIDMatchExistingBy = try container.decodeIfPresent(String.self, forKey: .authOpenIDMatchExistingBy)
            authOpenIDSubfolderForRedirectURLs = try container.decodeIfPresent(
                String.self,
                forKey: .authOpenIDSubfolderForRedirectURLs
            )
            authOpenIDClientID = try container.decodeIfPresent(String.self, forKey: .authOpenIDClientID)
            authOpenIDClientSecret = try container.decodeIfPresent(String.self, forKey: .authOpenIDClientSecret)
            authOpenIDMobileRedirectURIs = try container.decodeIfPresent(
                [String].self,
                forKey: .authOpenIDMobileRedirectURIs
            )
            authOpenIDGroupClaim = try container.decodeIfPresent(String.self, forKey: .authOpenIDGroupClaim)
            authOpenIDAdvancedPermsClaim = try container.decodeIfPresent(
                String.self,
                forKey: .authOpenIDAdvancedPermsClaim
            )
            authOpenIDSamplePermissions = try container.decode(String.self, forKey: .authOpenIDSamplePermissions)
        }

    }

    enum AudiobookshelfError: Error, Sendable {

        case forbidden

    }

}
