//
//  AudioTrack.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct AudioTrack {
    
    /// The index of the audio track.
    public let index: Int
    
    /// When in the audio file (in seconds) the track starts.
    public let startOffset: Float
    
    /// The length (in seconds) of the audio track.
    public let duration: Float
    
    /// The filename of the audio file the audio track belongs to.
    public let title: String
    
    /// The URL path of the audio file.
    public let contentUrl: String
    
    /// The MIME type of the audio file.
    public let mimeType: String
    
    ///The metadata of the audio file.
    public let metadata: FileMetadata?
    
}

extension AudioTrack: Decodable {}
extension AudioTrack: Sendable {}
