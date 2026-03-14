//
//  SyncOpenSession.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-03.
//

import Foundation
import RagnarNetworking

/// This endpoint syncs the position of an open listening session from the client to the server and returns the session.
public struct SyncOpenSession: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        /// Sync Open Session Parameters
        ///
        /// - Parameters:
        ///   - sessionID: The ID of the listening session.
        ///   - currentTime: The current time (in seconds) of the playback position.
        ///   - timeListened: The amount of time (in seconds) the user has spent listening since the last session sync.
        ///   - duration: The total duration (in seconds) of the playing item.
        public init(
            sessionID: String,
            currentTime: Float,
            timeListened: Float,
            duration: Float
        ) {
            self.path = "/api/session/\(sessionID)/sync"

            self.body = Payload(
                currentTime: currentTime,
                timeListened: timeListened,
                duration: duration
            )
        }

    }

    // MARK: Response

    public typealias Response = String

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

        case internalServerError

    }

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .decode),
        /// User is not allowed to access another user's open session.
        .code(403, .error(AudiobookshelfError.forbidden)),
        /// No listening session with the provided ID is open, or the session belongs to another user.
        .code(404, .error(AudiobookshelfError.notFound)),
        /// There was an error syncing the session.
        .code(500, .error(AudiobookshelfError.internalServerError))
    ]

}

public extension SyncOpenSession.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let currentTime: Float

        let timeListened: Float

        let duration: Float

    }

}
