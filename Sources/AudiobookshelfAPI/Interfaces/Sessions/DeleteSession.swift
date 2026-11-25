//
//  DeleteSession.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-23.
//

import Foundation
import RagnarNetworking

/// This endpoint deletes a specific persisted playback session.
/// On server 2.38.0+, a non-admin user cannot delete another user's session, even with delete permission.
/// Deleting another user's session requires admin/root access in addition to existing permission rules.
public struct DeleteSession: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Delete Session Request
        ///
        /// - Parameter sessionID: The ID of the playback session to delete.
        public init(sessionID: String) {
            self.path = "/api/sessions/\(sessionID)"
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case notFound

        /// Insufficient permissions or a session owned by another user.
        case forbidden

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            /// Insufficient permissions or a session owned by another user.
            .code(403, .error(AudiobookshelfError.forbidden)),
            /// Session with the provided ID was not found.
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}
