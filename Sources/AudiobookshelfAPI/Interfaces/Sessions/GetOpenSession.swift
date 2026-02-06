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

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Get Open Session Parameters
        ///
        /// - Parameter sessionID: The ID of the open listening session to retrieve.
        public init(sessionID: String) {
            self.path = "/api/session/\(sessionID)"
        }

    }

    // MARK: Response

    public typealias Response = PlaybackSession

    public enum AudiobookshelfError: Error, Sendable {

        case notFound

    }

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .decode),
        /// No listening session with the provided ID is open, or the session belongs to another user.
        .code(404, .error(AudiobookshelfError.notFound)),
    ]

}
