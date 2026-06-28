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

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/api/auth-settings"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        public init() {}

    }

    // MARK: Response

    public static let responseCases: ResponseMap = [

        .code(200, .decode)
    ]

}

public extension GetAuthSettings {

    struct Response: Decodable, Sendable {

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

    }

}
