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

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

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
        ) throws {
            self.path = "/api/items/\(libraryItemId)/play/\(episodeId)"
            self.body = try JSONEncoder().encode(
                Body(
                    deviceInfo: deviceInfo,
                    forceDirectPlay: forceDirectPlay,
                    forceTranscode: forceTranscode,
                    mediaPlayer: mediaPlayer,
                    supportedMimeTypes: supportedMimeTypes
                )
            )
        }
    }

    // MARK: Response

    public typealias Response = PlaybackSession

    public enum AudiobookshelfError: Error {
        case badRequest
        case forbidden
        case notFound
    }

    public static let responseCases: ResponseCases = [
        200: .success(Response.self),
        400: .failure(AudiobookshelfError.badRequest),
        403: .failure(AudiobookshelfError.forbidden),
        404: .failure(AudiobookshelfError.notFound)
    ]
}

public extension StartEpisodePlaybackSession.Parameters {

    struct Body: Encodable {
        let deviceInfo: StartPlaybackSession.Parameters.DeviceInfo?
        let forceDirectPlay: Bool?
        let forceTranscode: Bool?
        let mediaPlayer: String?
        let supportedMimeTypes: [String]?
    }
}
