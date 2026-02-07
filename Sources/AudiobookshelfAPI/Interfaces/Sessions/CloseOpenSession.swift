//
//  CloseOpenSession.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-20.
//

import Foundation
import RagnarNetworking

/// This endpoint closes an open listening session. Optionally provide sync data to update the session before closing
/// it.
public struct CloseOpenSession: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {
        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = CloseBody

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        /// Close Open Session Parameters
        ///
        /// - Parameters:
        ///   - sessionID: The ID of the listening session.
        ///   - currentTime: The current time (in seconds) of the playback position.
        ///   - timeListened: The amount of time (in seconds) the user has spent listening since the last session sync.
        ///   - duration: The total duration (in seconds) of the playing item.
        public init(
            sessionID: String,
            currentTime: Float? = nil,
            timeListened: Float? = nil,
            duration: Float? = nil
        ) {
            self.path = "/api/session/\(sessionID)/close"

            self.body = CloseBody(
                currentTime: currentTime,
                timeListened: timeListened,
                duration: duration
            )
        }

    }

    // MARK: Response

    public typealias Response = String

    public enum AudiobookshelfError: Error, Sendable {

        case notFound

    }

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .decode),
        /// No listening session with the provided ID is open, or the session belongs to another user.
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}

public extension CloseOpenSession.Parameters {

    struct CloseBody: RequestBody, Encodable, Sendable {

        public let currentTime: Float?

        public let timeListened: Float?

        public let duration: Float?

    }

}
