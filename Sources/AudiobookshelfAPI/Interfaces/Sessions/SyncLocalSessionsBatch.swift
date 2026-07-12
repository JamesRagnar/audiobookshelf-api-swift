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

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationType = .bearer

        /// Sync Local Sessions Batch Parameters
        ///
        /// - Parameters:
        ///   - sessions: The array of local playback session data to sync with the server.
        ///   - deviceInfo: Optional device info to associate with synced sessions.
        public init(
            sessions: [SyncLocalSession.Parameters.LocalPlaybackSession],
            deviceInfo: LocalDeviceInfo? = nil
        ) {
            self.body = Payload(
                sessions: sessions,
                deviceInfo: deviceInfo
            )
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let results: [SyncResult]

    }

    public struct SyncResult: Decodable, Sendable {

        public let id: String

        public let success: Bool

        public let progressSynced: Bool?

        public let error: String?

    }

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

public extension SyncLocalSessionsBatch.Parameters {

    /// Device metadata to associate with a batch sync request.
    struct LocalDeviceInfo: Encodable, Sendable {

        /// A stable identifier for the device (e.g. `UIDevice.current.identifierForVendor`).
        public let deviceId: String?

        /// The client app's version string (e.g. `CFBundleShortVersionString`).
        public let clientVersion: String?

        /// A human-readable name for the device (e.g. "James's iPhone").
        public let deviceName: String?

        /// The browser name. Typically nil for native clients.
        public let browserName: String?

        /// The operating system name (e.g. "iOS").
        public let osName: String?

        /// The operating system version string (e.g. "17.4").
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

    struct Payload: RequestBody, Encodable, Sendable {

        let sessions: [SyncLocalSession.Parameters.LocalPlaybackSession]

        let deviceInfo: LocalDeviceInfo?

    }

}
