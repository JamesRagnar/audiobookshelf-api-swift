//
//  RefreshToken.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2025-08-23.
//

import Foundation
import RagnarNetworking

/// Generate a new authentication token from a User's refresh token.
public struct RefreshToken: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/auth/refresh"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]?

        public let body: Body? = nil

        public let authentication: AuthenticationType = .none

        /// Login Parameters
        ///
        /// - Parameters:
        ///   - refreshToken: JWT refresh token
        public init(refreshToken: String) {
            self.headers = [
                "x-refresh-token": refreshToken
            ]
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        /// The authenticated user.
        public let user: User

        /// The ID of the first library in the list the user has access to.
        public let userDefaultLibraryID: String

        /// The server's settings.
        public let serverSettings: ServerSettings

        /// The server's installation source.
        public let source: String

        enum CodingKeys: String, CodingKey {
            case user
            case userDefaultLibraryID = "userDefaultLibraryId"
            case serverSettings
            case source = "Source"
        }

    }

    public enum AudiobookshelfError: Error, Sendable {

        case unauthorized

    }

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .decode),
        /// Invalid username or password.
        .code(401, .error(AudiobookshelfError.unauthorized))
    ]

}
