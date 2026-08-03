//
//  GetAllUsers.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// List all users.
public struct GetAllUsers: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String = "/api/users"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        public init() {}

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// All users on the server.
        public let users: [User]

    }

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(403, .error(AudiobookshelfError.forbidden))
        ]
    )

}
