//
//  DeleteUser.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Delete a user.
public struct DeleteUser: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Delete User Request
        ///
        /// - Parameter userId: The ID of the user to delete.
        public init(userId: String) {
            self.path = "/api/users/\(userId)"
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        public let success: Bool

    }

    public enum AudiobookshelfError: Error, Sendable {

        /// You cannot delete your own user.
        case badRequest

        /// The target is the root user, which cannot be deleted.
        case forbidden

        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}
