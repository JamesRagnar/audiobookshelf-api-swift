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

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = LocalPlaybackSession

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        /// Sync Local Session Parameters
        ///
        /// - Parameter session: The local playback session data to sync with the server.
        public init(session: LocalPlaybackSession) {
            self.body = session
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case internalServerError

    }

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .noContent),
        /// Invalid request data.
        .code(400, .error(AudiobookshelfError.badRequest)),
        /// Syncing failed.
        .code(500, .error(AudiobookshelfError.internalServerError))
    ]

}

public extension SyncLocalSession.Parameters {

    /// A local playback session to be synced with the server.
    /// This represents the client-side data sent when syncing local session state.
    struct LocalPlaybackSession: RequestBody, Encodable, Sendable {

        /// Client-generated session identifier echoed by batch sync results.
        public let id: String

        /// The ID of the library item.
        public let libraryItemId: String

        /// The ID of the podcast episode. Optional, only for podcast episodes.
        public let episodeId: String?

        /// The media type of the library item.
        public let mediaType: String

        /// The total duration (in seconds) of the playing item.
        public let duration: Float

        /// The current time (in seconds) of the playback position.
        public let currentTime: Float

        /// The time (in seconds) where the playback session started.
        public let startTime: Float

        /// The amount of time (in seconds) the user has spent listening.
        public let timeListening: Float

        /// The time (in ms since POSIX epoch) when the session was started.
        public let startedAt: Int

        /// The time (in ms since POSIX epoch) when the session was last updated.
        public let updatedAt: Int

        public init(
            id: String,
            libraryItemId: String,
            episodeId: String? = nil,
            mediaType: String,
            duration: Float,
            currentTime: Float,
            startTime: Float,
            timeListening: Float,
            startedAt: Int,
            updatedAt: Int
        ) {
            self.id = id
            self.libraryItemId = libraryItemId
            self.episodeId = episodeId
            self.mediaType = mediaType
            self.duration = duration
            self.currentTime = currentTime
            self.startTime = startTime
            self.timeListening = timeListening
            self.startedAt = startedAt
            self.updatedAt = updatedAt
        }

    }

    struct LocalDeviceInfo: Encodable, Sendable {

        public let deviceId: String?

        public let clientVersion: String?

        public let deviceName: String?

        public let browserName: String?

        public let osName: String?

        public let osVersion: String?

        public init(
            deviceId: String? = nil,
            clientVersion: String? = nil,
            deviceName: String? = nil,
            browserName: String? = nil,
            osName: String? = nil,
            osVersion: String? = nil
        ) {
            self.deviceId = deviceId
            self.clientVersion = clientVersion
            self.deviceName = deviceName
            self.browserName = browserName
            self.osName = osName
            self.osVersion = osVersion
        }

    }

}
