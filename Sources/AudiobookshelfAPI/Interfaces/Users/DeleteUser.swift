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

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// Delete User Parameters
        ///
        /// - Parameter userId: The ID of the user to delete.
        public init(userId: String) {
            self.path = "/api/users/\(userId)"
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let success: Bool

    }

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}
