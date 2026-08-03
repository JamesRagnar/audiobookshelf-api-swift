//
//  DeleteYourAuthSession.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-07-27.
//

import Foundation
import RagnarNetworking

/// This endpoint deletes one of your authentication sessions, logging that device out.
///
/// Deleting the session the request was made with invalidates the caller's own refresh token. Use
/// `Logout` for that case instead, so the refresh token cookie is cleared as well.
///
/// - Note: Requires server `>= 2.36.0`.
public struct DeleteYourAuthSession: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Delete Your Auth Session Request
        ///
        /// - Parameter sessionID: The ID of the auth session to delete.
        public init(
            sessionID: String
        ) {
            self.path = "/api/me/sessions/\(sessionID)"
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        /// The session ID was not a valid UUID.
        case badRequest

        /// Guest users cannot manage sessions.
        case forbidden

        /// No session with that ID belongs to your user.
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
