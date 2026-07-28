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
/// A successful change always destroys the user's other authentication sessions. Pass `refreshToken`
/// to ask the server to keep the calling session alive and hand back a replacement token pair; the
/// caller must store those in place of its existing pair.
///
/// Read ``Response/user`` to find out what happened. When it is `nil` the password was still changed,
/// but no session survived and the caller must re-authenticate with the new password. That is the
/// only outcome on servers below 2.36.0, which ignore `refreshToken` entirely, and it can also happen
/// on 2.36.0 and newer when the supplied refresh token no longer matches a live session.
public struct UpdatePassword: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String = "/api/me/password"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]?

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationType = .bearer

        /// Update Password Parameters
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

    public static let responseHandler: ResponseHandler.Type = UpdatePasswordResponseHandler.self

    public static let responseCases: ResponseMap = [
        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden))
    ]
}

public extension UpdatePassword.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {
        let password: String?
        let newPassword: String?
    }
}

// MARK: - Response Handling

/// Resolves the two different 200 bodies `PATCH /api/me/password` can return.
///
/// The server answers with a JSON object carrying rotated tokens when it kept the calling session
/// alive, and with a bare `200 OK` whose body is the plain-text status message when it did not. Both
/// are status 200, so the difference cannot be expressed in `responseCases`.
public enum UpdatePasswordResponseHandler: ResponseHandler {

    public static func handle<T: Interface>(
        _ response: (data: Data, response: URLResponse),
        for interface: T.Type
    ) throws(ResponseError) -> T.Response {
        do {
            return try DefaultResponseHandler.handle(response, for: interface)
        } catch {
            // Only substitute for a body that is not JSON at all. A JSON body that failed to decode
            // is a real contract mismatch and must keep surfacing as one.
            guard
                case .decoding(let data, let snapshot, _) = error,
                snapshot.statusCode == 200,
                (try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])) == nil,
                let unrotated = UpdatePassword.Response(
                    success: true,
                    user: nil
                ) as? T.Response
            else {
                throw error
            }

            return unrotated
        }
    }

}
