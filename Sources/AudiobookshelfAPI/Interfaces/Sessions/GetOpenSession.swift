//
//  GetOpenSession.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-23.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves details of an active playback session.
public struct GetOpenSession: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Get Open Session Request
        ///
        /// - Parameter sessionID: The ID of the open listening session to retrieve.
        public init(sessionID: String) {
            self.path = "/api/session/\(sessionID)"
        }

    }

    // MARK: Response

    public typealias Response = PlaybackSession

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            /// User is not allowed to access another user's open session.
            .code(403, .error(AudiobookshelfError.forbidden)),
            /// No listening session with the provided ID is open, or the session belongs to another user.
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}
