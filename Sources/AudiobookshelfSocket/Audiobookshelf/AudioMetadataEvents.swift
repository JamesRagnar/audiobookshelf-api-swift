//
//  AudioMetadataEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation

// MARK: - Audio Metadata Events

/// A library item has started updating its audio files' metadata.
public struct AudioMetadataStartedEvent: SocketEvent {
    
    public static let name = "audio_metadata_started"
    
    public typealias Schema = AudioMetadataStartedEventObject

}

/// A library item has finished updating its audio files' metadata.
public struct AudioMetadataFinishedEvent: SocketEvent {
    
    public static let name = "audio_metadata_finished"
    
    public typealias Schema = AudioMetadataFinishedEventObject

}

/// An audio file has started updating its metadata.
public struct AudioFileMetadataStartedEvent: SocketEvent {
    
    public static let name = "audiofile_metadata_started"
    
    public typealias Schema = AudioFileMetadataStartedEventObject

}

/// An audio file has finished updating its metadata.
public struct AudioFileMetadataFinishedEvent: SocketEvent {
    
    public static let name = "audiofile_metadata_finished"
    
    public typealias Schema = AudioFileMetadataFinishedEventObject

}

// MARK: - Audio Metadata Event Objects

/// The object representing the audio metadata started event.
public struct AudioMetadataStartedEventObject: Decodable {
    
    /// The ID of the user that requested the metadata update.
    let userId: String
    
    /// The ID of the library item whose audio files' metadata are being updated.
    let libraryItemId: String
    
    /// The time (in ms since POSIX epoch) when the metadata update request was sent.
    let startedAt: Int
    
    /// The audio files whose metadata is being updated.
    let audioFiles: [EventAudioFile]
    
}

/// The object representing the audio metadata finished event.
public struct AudioMetadataFinishedEventObject: Decodable {
    
    /// The ID of the user that requested the metadata update.
    let userId: String
    
    /// The ID of the library item whose audio files' metadata are being updated.
    let libraryItemId: String
    
    /// The time (in ms since POSIX epoch) when the metadata update request was sent.
    let startedAt: Int
    
    /// The audio files whose metadata is being updated.
    let audioFiles: [EventAudioFile]
    
    /// The results of the audio file metadata updates.
    let results: [AudioFileMetadataFinishedEventObject]
    
    /// The time (in ms) it took to complete the metadata updates (approx. finishedAt - startedAt)
    let elapsed: Int
    
    /// The time (in ms since POSIX epoch) when the metadata updates were finished.
    let finishedAt: Int
    
}

/// The object representing the audio file metadata started event.
public struct AudioFileMetadataStartedEventObject: Decodable {
    
    /// The ID of the library item which the audio file belongs to.
    let libraryItemId: String
    
    /// The index of the audio file.
    let index: Int
    
    /// The inode of the audio file.
    let ino: String
    
    /// The filename of the audio file.
    let filename: String
    
}

/// The object representing the audio file metadata finished event.
public struct AudioFileMetadataFinishedEventObject: Decodable {
    
    /// The ID of the library item which the audio file belongs to.
    let libraryItemId: String
    
    /// The index of the audio file.
    let index: Int
    
    /// The inode of the audio file.
    let ino: String
    
    /// The filename of the audio file.
    let filename: String
    
    /// Whether the audio file's metadata was successfully updated.
    let success: Bool
    
}

/// The object representing an individual audio file in an event.
public struct EventAudioFile: Decodable {
    
    /// The index of the audio file.
    let index: Int
    
    /// The inode of the audio file.
    let ino: String
    
    /// The filename of the audio file.
    let filename: String
    
}
