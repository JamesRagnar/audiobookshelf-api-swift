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

        public let path: String = "/api/session/local"

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public let body: RequestBody?

        public let authentication: AuthenticationType = .bearer

        /// Sync Local Session Parameters
        ///
        /// - Parameter session: The local playback session data to sync with the server.
        public init(session: LocalPlaybackSession) {
            self.body = .json(session)
        }

    }

    // MARK: Response

    public typealias Response = String

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
