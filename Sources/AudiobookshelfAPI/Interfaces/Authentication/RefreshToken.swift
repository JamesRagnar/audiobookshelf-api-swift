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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String = "/auth/refresh"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]?

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = nil

        /// Login Request
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

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// The authenticated user.
        public let user: User

        /// The ID of the first library in the list the user has access to.
        public let userDefaultLibraryID: String

        /// The server's settings.
        public let serverSettings: ServerSettings

        /// The server's installation source.
        public let source: String

        /// The eReader devices available to the authenticated user.
        public let ereaderDevices: [EReaderDevice]

        enum CodingKeys: String, CodingKey {
            case user
            case userDefaultLibraryID = "userDefaultLibraryId"
            case serverSettings
            case source = "Source"
            case ereaderDevices
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            user = try container.decode(User.self, forKey: .user)
            userDefaultLibraryID = try container.decode(String.self, forKey: .userDefaultLibraryID)
            serverSettings = try container.decode(ServerSettings.self, forKey: .serverSettings)
            source = try container.decode(String.self, forKey: .source)
            ereaderDevices = try container.decodeIfPresent([EReaderDevice].self, forKey: .ereaderDevices) ?? []
        }

    }

    public enum AudiobookshelfError: Error, Sendable {

        case unauthorized

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            /// Invalid username or password.
            .code(401, .error(AudiobookshelfError.unauthorized))
        ]
    )

}
