//
//  UpdatePassword.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-27.
//

import Foundation
import RagnarNetworking

/// Update the authenticated user's password.
///
/// A successful change destroys the user's other authentication sessions. Pass `refreshToken` to
/// keep the calling session alive and receive a replacement token pair, which must be stored in
/// place of the existing one.
///
/// A nil ``Response/user`` means the password changed but no session survived, so the caller is
/// logged out and must re-authenticate. That is the only outcome below 2.36.0, where `refreshToken`
/// is ignored, and also occurs on 2.36.0 when the token no longer matches a live session.
public struct UpdatePassword: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .patch

        public let path: String = "/api/me/password"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]?

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Update Password Request
        ///
        /// - Parameters:
        ///   - currentPassword: The user's current password.
        ///   - newPassword: The new password to set.
        ///   - refreshToken: The JWT refresh token for the current session. Pass this to keep the
        ///     calling session alive and receive rotated tokens. Requires server `>= 2.36.0`; older
        ///     servers ignore it and log the caller out along with every other session.
        public init(
            currentPassword: String?,
            newPassword: String?,
            refreshToken: String? = nil
        ) {
            self.body = Payload(password: currentPassword, newPassword: newPassword)

            if let refreshToken {
                self.headers = ["x-refresh-token": refreshToken]
            } else {
                self.headers = nil
            }
        }
    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        /// Whether the password was updated.
        public let success: Bool

        /// The replacement tokens for the calling session.
        ///
        /// `nil` when the server changed the password without rotating, which means every session
        /// was destroyed and the caller is logged out.
        public let user: RotatedTokens?

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

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden))
        ]
    )
}

public extension UpdatePassword.Request {

    struct Payload: RequestBody, Encodable, Sendable {
        let password: String?
        let newPassword: String?
    }
}

// MARK: - Response Decoding

/// Resolves the two 200 bodies `PATCH /api/me/password` can return.
///
/// The server sends rotated tokens as JSON when it kept the calling session alive, and a bare
/// `200 OK` with a plain-text body when it did not. Both are status 200, so the difference cannot
/// be expressed in `responses`.
extension UpdatePassword.Response: InterfaceResponse {

    public static func decode(
        from data: Data,
        metadata: HTTPResponseSnapshot,
        using decoder: ResponseDecoder
    ) throws -> UpdatePassword.Response {
        guard (try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])) != nil else {
            return UpdatePassword.Response(success: true, user: nil)
        }

        return try decoder.decode(UpdatePassword.Response.self, from: data)
    }

}
