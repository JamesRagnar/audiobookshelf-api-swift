//
//  BatchDeleteSessions.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Batch delete playback sessions.
public struct BatchDeleteSessions: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String = "/api/sessions/batch/delete"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Batch Delete Sessions Request
        ///
        /// - Parameters:
        ///   - sessionIds: Array of session IDs to delete.
        public init(sessionIds: [String]) {
            self.body = Payload(sessions: sessionIds)
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

        case internalError

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(500, .error(AudiobookshelfError.internalError))
        ]
    )

}

public extension BatchDeleteSessions.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let sessions: [String]

    }

}
