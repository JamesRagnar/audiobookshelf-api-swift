//
//  PlaybackSession.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct PlaybackSession {
    
    /// The ID of the playback session.
    public let id: String
    
    /// The ID of the user the playback session is for.
    public let userId: String
    
    /// The ID of the library that contains the library item.
    public let libraryId: String
    
    /// The ID of the library item.
    public let libraryItemId: String
    
    /// The ID of the podcast episode. Will be null if this playback session was started without an episode ID.
    public let episodeId: String?
    
    /// The media type of the library item.
    public let mediaType: MediaType
    
    /// The metadata of the library item's media.
    public let mediaMetadata: BookMetadata
    
    /// If the library item is a book, the chapters it contains.
    public let chapters: [BookChapter]
    
    /// The title of the playing item to show to the user.
    public let displayTitle: String
    
    /// The author of the playing item to show to the user.
    public let displayAuthor: String
    
    /// The cover path of the library item's media.
    public let coverPath: String
    
    /// The total duration (in seconds) of the playing item.
    public let duration: Float
    
    /// What play method the playback session is using.
    public let playMethod: PlayMethod
    
    /// The given media player when the playback session was requested.
    public let mediaPlayer: String
    
    /// The given device info when the playback session was requested.
    public let deviceInfo: DeviceInfo
    
    /// The server version the playback session was started with.
    public let serverVersion: String
    
    /// The day (in the format YYYY-MM-DD) the playback session was started.
    public let date: String
    
    /// The day of the week the playback session was started.
    public let dayOfWeek: String
    
    /// The amount of time (in seconds) the user has spent listening using this playback session.
    public let timeListening: Float
    
    /// The time (in seconds) where the playback session started.
    public let startTime: Float
    
    /// The current time (in seconds) of the playback position.
    public let currentTime: Float
    
    /// The time (in ms since POSIX epoch) when the playback session was started.
    public let startedAt: Int
    
    /// The time (in ms since POSIX epoch) when the playback session was last updated.
    public let updatedAt: Int

    // MARK: Playback Session Expanded
    
    /// The audio tracks that are being played with the playback session.
    /// - Note: Playback Session Expanded - Added Attribute
    public let audioTracks: [AudioTrack]?
    
    /// The video track that is being played with the playback session. Will be null if the playback session is for a book or podcast.
    /// - Note: Playback Session Expanded - Added Attribute
    public let videoTrack: VideoTrack?

    /// The library item of the playback session.
    /// - Note: Playback Session Expanded - Added Attribute
    public let libraryItem: LibraryItem?

}

extension PlaybackSession: Decodable {}
extension PlaybackSession: Sendable {}

extension PlaybackSession {
    
    public enum MediaType: String, Decodable, Sendable {
        
        case book
        
        case podcast
        
    }
    
    public enum PlayMethod: Int, Decodable, Sendable {
        
        case directPlay = 0
        
        case directStream = 1
        
        case transcode = 2
        
        case local = 3
        
    }
    
}
