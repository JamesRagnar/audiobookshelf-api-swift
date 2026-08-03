//
//  Logout.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation
import RagnarNetworking

/// This endpoint logs out a client from the server.
public struct Logout: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String = "/logout"

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]?

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = nil

        /// Logout Request
        ///
        /// - Parameters:
        ///   - refreshToken: The JWT refresh token.
        ///   - allDevices: Whether to destroy every authentication session belonging to the user rather
        ///     than only the one this refresh token identifies. Requires server `>= 2.36.0`; older
        ///     servers ignore the parameter and log out the current session only.
        public init(
            refreshToken: String,
            allDevices: Bool = false
        ) {
            self.headers = [
                "x-refresh-token": refreshToken
            ]
            self.queryItems = allDevices ? [URLQueryItem(name: "allDevices", value: "1")] : nil
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// OIDC logout URL
        public let redirectURL: String?

        enum CodingKeys: String, CodingKey {
            case redirectURL = "redirect_url"
        }

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200)
    )

}
