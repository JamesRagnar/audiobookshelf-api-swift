//
//  UpdateUser.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Update a user.
public struct UpdateUser: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        public init(
            userId: String,
            username: String? = nil,
            password: String? = nil,
            type: User.UserType? = nil,
            isActive: Bool? = nil,
            isLocked: Bool? = nil,
            librariesAccessible: [String]? = nil,
            permissions: UserPermissions? = nil
        ) {
            self.path = "/api/users/\(userId)"
            self.body = Payload(
                username: username,
                password: password,
                type: type,
                isActive: isActive,
                isLocked: isLocked,
                librariesAccessible: librariesAccessible,
                permissions: permissions
            )
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// Whether the update was applied.
        public let success: Bool

        /// The updated user.
        ///
        /// - Note: This endpoint never returns rotated tokens, even when the update invalidated the
        ///   user's sessions. An admin changing their own password should use
        ///   `UpdatePasswordWithTokenRotation` instead.
        public let user: User

    }

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

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

public extension UpdateUser.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let username: String?

        let password: String?

        let type: User.UserType?

        let isActive: Bool?

        let isLocked: Bool?

        let librariesAccessible: [String]?

        let permissions: UserPermissions?

    }

}
