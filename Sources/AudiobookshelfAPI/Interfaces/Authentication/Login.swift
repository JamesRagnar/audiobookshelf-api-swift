//
//  Login.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-19.
//

import Foundation
import RagnarNetworking

/// This endpoint logs in a client to the server, returning information about the user and server.
public struct Login: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/login"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]?

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationType = .none

        /// Login Parameters
        ///
        /// - Parameters:
        ///   - username: The username to log in with.
        ///   - password: The password of the user.
        ///   - returnRefreshToken: If true, returns the user's refresh token in response body
        public init(
            username: String,
            password: String,
            returnRefreshToken: Bool
        ) {
            self.headers = [
                "x-return-tokens": returnRefreshToken.description
            ]

            self.body = Payload(
                username: username,
                password: password
            )
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

public extension Login.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let username: String

        let password: String

    }

}
