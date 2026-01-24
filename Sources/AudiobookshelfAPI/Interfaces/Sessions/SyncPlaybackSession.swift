//
//  SyncPlaybackSession.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Sync local playback session with the server.
public struct SyncPlaybackSession: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        /// Sync Playback Session Parameters
        ///
        /// - Parameters:
        ///   - sessionId: The ID of the session to sync.
        ///   - currentTime: The current playback time in seconds.
        ///   - timeListened: The time listened in this session in seconds.
        ///   - duration: The total duration of the media in seconds.
        public init(
            sessionId: String,
            currentTime: Double,
            timeListened: Double,
            duration: Double
        ) throws {
            self.path = "/api/session/\(sessionId)/sync"
            self.body = try JSONEncoder().encode(
                Body(
                    currentTime: currentTime,
                    timeListened: timeListened,
                    duration: duration
                )
            )
        }

    }

    // MARK: Response

    public typealias Response = PlaybackSession

    public enum AudiobookshelfError: Error {

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        404: .failure(AudiobookshelfError.notFound),

    ]

}

extension SyncPlaybackSession.Parameters {

    struct Body: Encodable {

        let currentTime: Double

        let timeListened: Double

        let duration: Double

    }

}
