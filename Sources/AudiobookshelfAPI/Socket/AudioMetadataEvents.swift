//
//  AudioMetadataEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import RagnarNetworking

// MARK: - Track Events

// Emitted by the audio metadata embed and M4B merge tools. All three are admin-only and carry the
// same identifying pair: the library item being processed and the inode of the audio file within it.
//
// The older `audio_metadata_started`, `audio_metadata_finished`, `audiofile_metadata_started` and
// `audiofile_metadata_finished` events were removed from the server before the package's minimum
// supported version and are not represented here.

/// Processing of an audio file started. (Admin Only)
public struct TrackStartedEvent: SocketEvent {

    public static let name = "track_started"

    public typealias Schema = TrackStartedEventObject

}

/// Progress update while processing an audio file. (Admin Only)
public struct TrackProgressEvent: SocketEvent {

    public static let name = "track_progress"

    public typealias Schema = TrackProgressEventObject

}

/// Processing of an audio file finished. (Admin Only)
public struct TrackFinishedEvent: SocketEvent {

    public static let name = "track_finished"

    public typealias Schema = TrackFinishedEventObject

}

// MARK: - Track Event Objects

/// The object representing the track started event.
public struct TrackStartedEventObject: Decodable, Sendable {

    /// The ID of the library item being processed.
    public let libraryItemId: String

    /// The inode of the audio file being processed.
    ///
    /// Null when the scanner could not read an inode for the file, matching ``AudioFile/ino``. The
    /// M4B merge tool can also omit the key entirely when the index it looks up is out of range.
    public let ino: String?

}

/// The object representing the track progress event.
public struct TrackProgressEventObject: Decodable, Sendable {

    /// The ID of the library item being processed.
    public let libraryItemId: String

    /// The inode of the audio file being processed.
    ///
    /// Null when the scanner could not read an inode for the file, matching ``AudioFile/ino``. The
    /// M4B merge tool can also omit the key entirely when the index it looks up is out of range.
    public let ino: String?

    /// Progress percentage (0-100) through this audio file.
    public let progress: Float

}

/// The object representing the track finished event.
public struct TrackFinishedEventObject: Decodable, Sendable {

    /// The ID of the library item being processed.
    public let libraryItemId: String

    /// The inode of the audio file that finished processing.
    ///
    /// Null when the scanner could not read an inode for the file, matching ``AudioFile/ino``. The
    /// M4B merge tool can also omit the key entirely when the index it looks up is out of range.
    public let ino: String?

}
