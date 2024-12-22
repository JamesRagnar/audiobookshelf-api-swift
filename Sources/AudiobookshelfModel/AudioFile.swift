//
//  AudioFile.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct AudioFile {
    
    /// The index of the audio file.
    public let index: Int
    
    /// The inode of the audio file.
    public let ino: String
    
    /// The audio file's metadata.
    public let metadata: FileMetadata
    
    /// The time (in ms since POSIX epoch) when the audio file was added to the library.
    public let addedAt: Int
    
    /// The time (in ms since POSIX epoch) when the audio file last updated. (Read Only)
    public let updatedAt: Int
    
    /// The track number of the audio file as pulled from the file's metadata. Will be null if unknown.
    public let trackNumFromMeta: Int?
    
    /// The disc number of the audio file as pulled from the file's metadata. Will be null if unknown.
    public let discNumFromMeta: Int?
    
    /// The track number of the audio file as determined from the file's name. Will be null if unknown.
    public let trackNumFromFilename: Int?
    
    /// The track number of the audio file as determined from the file's name. Will be null if unknown.
    public let discNumFromFilename: Int?
    
    /// Whether the audio file has been manually verified by a user.
    public let manuallyVerified: Bool
    
    /// Whether the audio file has been marked for exclusion.
    public let exclude: Bool
    
    /// Any error with the audio file. Will be null if there is none.
    public let error: String?
    
    /// The format of the audio file.
    public let format: String
    
    /// The total length (in seconds) of the audio file.
    public let duration: Float
    
    /// The bit rate (in bit/s) of the audio file.
    public let bitRate: Int
    
    /// The language of the audio file.
    public let language: String?
    
    /// The codec of the audio file.
    public let codec: String
    
    /// The time base of the audio file.
    public let timeBase: String
    
    /// The number of channels the audio file has.
    public let channels: Int
    
    /// The layout of the audio file's channels.
    public let channelLayout: String
    
    /// If the audio file is part of an audiobook, the chapters the file contains.
    public let chapters: [BookChapter]
    
    /// The type of embedded cover art in the audio file. Will be null if none exists.
    public let embeddedCoverArt: String?
    
    /// The audio metadata tags from the audio file.
    public let metaTags: AudioMetaTags
    
    /// The MIME type of the audio file.
    public let mimeType: String
    
}

extension AudioFile: Decodable {}
extension AudioFile: Sendable {}
