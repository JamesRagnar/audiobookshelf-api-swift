//
//  StartEpisodePlaybackSession.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-27.
//

import Foundation
import RagnarNetworking

/// Start a playback session for a podcast episode.
public struct StartEpisodePlaybackSession: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationType = .bearer

        /// Start Episode Playback Session Parameters
        ///
        /// - Parameters:
        ///   - libraryItemId: The ID of the library item (podcast).
        ///   - episodeId: The ID of the podcast episode.
        ///   - deviceInfo: Device information for this session.
        ///   - forceDirectPlay: Force direct play mode.
        ///   - forceTranscode: Force transcode mode.
        ///   - mediaPlayer: Media player identifier.
        ///   - supportedMimeTypes: MIME types supported by the client.
        public init(
            libraryItemId: String,
            episodeId: String,
            deviceInfo: StartPlaybackSession.Parameters.DeviceInfo? = nil,
            forceDirectPlay: Bool? = nil,
            forceTranscode: Bool? = nil,
            mediaPlayer: String? = nil,
            supportedMimeTypes: [String]? = nil
        ) {
            self.path = "/api/items/\(libraryItemId)/play/\(episodeId)"
            self.body = Payload(
                deviceInfo: deviceInfo,
                forceDirectPlay: forceDirectPlay,
                forceTranscode: forceTranscode,
                mediaPlayer: mediaPlayer,
                supportedMimeTypes: supportedMimeTypes
            )
        }
    }

    // MARK: Response

    public typealias Response = PlaybackSession

    public enum AudiobookshelfError: Error, Sendable {
        case badRequest
        case forbidden
        case notFound
    }

    public static let responseCases: ResponseMap = [
        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound))
    ]
}

public extension StartEpisodePlaybackSession.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {
        let deviceInfo: StartPlaybackSession.Parameters.DeviceInfo?
        let forceDirectPlay: Bool?
        let forceTranscode: Bool?
        let mediaPlayer: String?
        let supportedMimeTypes: [String]?
    }
}
