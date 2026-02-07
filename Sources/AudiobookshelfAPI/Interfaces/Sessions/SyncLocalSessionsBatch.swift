//
//  SyncLocalSessionsBatch.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-23.
//

import Foundation
import RagnarNetworking

/// This endpoint batch syncs multiple local playback sessions from the client to the server.
public struct SyncLocalSessionsBatch: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/session/local-all"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = ArrayBody<SyncLocalSession.Parameters.LocalPlaybackSession>

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        /// Sync Local Sessions Batch Parameters
        ///
        /// - Parameter sessions: The array of local playback session data to sync with the server.
        public init(sessions: [SyncLocalSession.Parameters.LocalPlaybackSession]) {
            self.body = ArrayBody(sessions)
        }

    }

    // MARK: Response

    public typealias Response = String

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

    }

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .decode),
        /// Invalid request data or empty array provided.
        .code(400, .error(AudiobookshelfError.badRequest))
    ]

}
