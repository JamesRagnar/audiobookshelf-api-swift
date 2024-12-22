//
//  PlayLibraryItem.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-29.
//

import AudiobookshelfModel
import Foundation

/// This endpoint starts a playback session for a library item or podcast episode.
public struct PlayLibraryItem: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .post
        
        public let path: String
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data?
        
        public let authentication: AuthenticationType = .bearer
        
        /// Play Library Item Parameters
        ///
        /// - Parameters:
        ///   - libraryItemID: The ID of the library item.
        ///   - episodeID: The ID of the podcast episode.
        ///   - deviceInfo:  Information about the device.
        ///   - forceDirectPlay: Whether to force direct play of the library item.
        ///   - forceTranscode: Whether to force the server to transcode the audio.
        ///   - supportedMimeTypes: The MIME types that are supported by the client. If the MIME type of the audio file is not in this list, the server will transcode it.
        ///   - mediaPlayer: The media player the client is using.
        public init(
            libraryItemID: String,
            episodeID: String? = nil,
            deviceInfo: DeviceInfoParameters? = nil,
            forceDirectPlay: Bool? = nil,
            forceTranscode: Bool? = nil,
            supportedMimeTypes: [String]? = nil,
            mediaPlayer: String? = nil
        ) throws {
            var path = "/api/items/\(libraryItemID)/play"
            if let episodeID {
                path += "/\(episodeID)"
            }
            self.path = path
            
            self.body = try JSONEncoder().encode(
                Body(
                    deviceInfo: deviceInfo,
                    forceDirectPlay: forceDirectPlay,
                    forceTranscode: forceTranscode,
                    supportedMimeTypes: supportedMimeTypes,
                    mediaPlayer: mediaPlayer
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
        
        /// Success
        200: .success(Response.self),
        
        /// The library item does not have any audio tracks to play.
        404: .failure(AudiobookshelfError.notFound),
        
    ]
    
}

extension PlayLibraryItem.Parameters {
    
    struct Body: Codable {
        
        let deviceInfo: DeviceInfoParameters?
        
        let forceDirectPlay: Bool?
        
        let forceTranscode: Bool?
        
        let supportedMimeTypes: [String]?
        
        let mediaPlayer: String?
        
    }
    
    public struct DeviceInfoParameters: Codable {
        
        /// The client device identifier.
        public let deviceId: String
        
        /// The name of the client.
        public let clientName: String
        
        /// The version of the client.
        public let clientVersion: String
        
        /// The manufacturer of the client device.
        public let manufacturer: String?
        
        /// The model of the client device.
        public let model: String?
        
        /// For an Android client, the Android SDK version of the client.
        public let sdkVersion: Int?
        
        public init(
            deviceId: String,
            clientName: String,
            clientVersion: String,
            manufacturer: String?,
            model: String?,
            sdkVersion: Int?
        ) {
            self.deviceId = deviceId
            self.clientName = clientName
            self.clientVersion = clientVersion
            self.manufacturer = manufacturer
            self.model = model
            self.sdkVersion = sdkVersion
        }
        
    }
    
}
