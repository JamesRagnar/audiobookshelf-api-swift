//
//  UpdatePasswordWithTokenRotation.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-07-27.
//

import Foundation
import RagnarNetworking

/// Update the authenticated user's password and receive replacement tokens for the current session.
///
/// A password change destroys every other authentication session for the user. This variant sends the
/// current refresh token so the server keeps the calling session alive and returns rotated tokens for
/// it, which the caller must store in place of its existing pair.
///
/// - Important: Requires server `>= 2.36.0`. Older servers ignore the `x-refresh-token` header and
///   respond with an empty body, which fails to decode. Use `UpdatePassword` when the server version
///   is unknown or below 2.36.0; it works on every supported server but leaves the calling session
///   logged out on 2.36.0 and newer.
public struct UpdatePasswordWithTokenRotation: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String = "/api/me/password"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]?

        public typealias Body = UpdatePassword.Parameters.Payload

        public let body: Body

        public let authentication: AuthenticationType = .bearer

        /// Update Password With Token Rotation Parameters
        ///
        /// - Parameters:
        ///   - currentPassword: The user's current password.
        ///   - newPassword: The new password to set.
        ///   - refreshToken: The JWT refresh token for the current session.
        public init(
            currentPassword: String?,
            newPassword: String?,
            refreshToken: String
        ) {
            self.body = UpdatePassword.Parameters.Payload(password: currentPassword, newPassword: newPassword)
            self.headers = [
                "x-refresh-token": refreshToken
            ]
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        /// Whether the password was updated.
        public let success: Bool

        /// The replacement tokens for the current session.
        public let user: RotatedTokens

        public struct RotatedTokens: Decodable, Sendable {

            /// The new JWT access token. Replaces the token used for bearer authentication.
            public let accessToken: String

            /// The new JWT refresh token. Replaces the token stored for this session.
            public let refreshToken: String

        }

    }

    public enum AudiobookshelfError: Error, Sendable {

        /// The current password was incorrect, or the new password was invalid.
        case badRequest

        /// Guest users cannot change their password.
        case forbidden

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden))
    ]

}
