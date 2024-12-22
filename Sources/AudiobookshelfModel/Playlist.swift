//
//  Playlist.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct Playlist {
    
    /// The ID of the playlist.
    public let id: String
    
    /// The ID of the library the playlist belongs to.
    public let libraryId: String
    
    /// The ID of the user the playlist belongs to.
    public let userId: String
    
    /// The playlist's name.
    public let name: String
    
    /// The playlist's description.
    public let description: String?
    
    /// The path of the playlist's cover.
    public let coverPath: String?
    
    /// The items in the playlist.
    /// - Note: Playlist Expanded - items is Array of PlaylistItem Expanded
    public let items: [PlaylistItem]
    
    /// The time (in ms since POSIX epoch) when the playlist was last updated.
    public let lastUpdate: Int
    
    /// The time (in ms since POSIX epoch) when the playlist was created.
    public let createdAt: Int
    
}

extension Playlist: Decodable {}
extension Playlist: Sendable {}
