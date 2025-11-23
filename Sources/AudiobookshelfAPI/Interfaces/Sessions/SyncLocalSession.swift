//
//  SyncLocalSession.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-23.
//

import Foundation
import RagnarNetworking

/// This endpoint syncs a local playback session from the client to the server.
public struct SyncLocalSession: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/sessions/local"

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        /// Sync Local Session Parameters
        ///
        /// - Parameter session: The local playback session data to sync with the server.
        public init(session: LocalPlaybackSession) throws {
            self.body = try JSONEncoder().encode(session)
        }

    }

    // MARK: Response

    public typealias Response = PlaybackSession

    public enum AudiobookshelfError: Error {

        case badRequest

    }

    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self),

        /// Invalid request data.
        400: .failure(AudiobookshelfError.badRequest),

    ]

}
