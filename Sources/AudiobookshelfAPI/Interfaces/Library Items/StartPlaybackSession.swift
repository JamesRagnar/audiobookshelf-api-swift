//
//  StartPlaybackSession.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-27.
//

import Foundation
import RagnarNetworking

/// Start a playback session for a book.
public struct StartPlaybackSession: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Start Playback Session Request
        ///
        /// - Parameters:
        ///   - libraryItemId: The ID of the library item.
        ///   - deviceInfo: Device information for this session.
        ///   - forceDirectPlay: Force direct play mode.
        ///   - forceTranscode: Force transcode mode.
        ///   - mediaPlayer: Media player identifier.
        ///   - supportedMimeTypes: MIME types supported by the client.
        public init(
            libraryItemId: String,
            deviceInfo: DeviceInfo? = nil,
            forceDirectPlay: Bool? = nil,
            forceTranscode: Bool? = nil,
            mediaPlayer: String? = nil,
            supportedMimeTypes: [String]? = nil
        ) {
            self.path = "/api/items/\(libraryItemId)/play"
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
        case forbidden
        case notFound
    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )
}

public extension StartPlaybackSession.Request {

    struct Payload: RequestBody, Encodable, Sendable {
        let deviceInfo: DeviceInfo?
        let forceDirectPlay: Bool?
        let forceTranscode: Bool?
        let mediaPlayer: String?
        let supportedMimeTypes: [String]?
    }

    struct DeviceInfo: Encodable, Sendable {
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
