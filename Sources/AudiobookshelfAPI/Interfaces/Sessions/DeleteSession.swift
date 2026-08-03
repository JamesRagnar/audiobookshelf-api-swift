//
//  DeleteSession.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-23.
//

import Foundation
import RagnarNetworking

/// This endpoint deletes a specific playback session.
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

        /// You do not have the required permission.
        case forbidden

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(403, .error(AudiobookshelfError.forbidden)),
            /// Session with the provided ID does not exist or user cannot access it.
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}
