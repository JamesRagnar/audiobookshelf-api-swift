//
//  PlaylistItem.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct PlaylistItem {
    
    /// The ID of the library item the playlist item is for.
    public let libraryItemId: String
    
    /// The ID of the podcast episode the playlist item is for.
    public let episodeId: String?

    // MARK: Playlist Item Expanded
    
    /// The podcast episode the playlist item is for. Will only exist if episodeId is not null.
    /// - Note: Playlist Item Expanded - Added Attribute
    public let episode: PodcastEpisodeDownload?
    
    /// The library item the playlist item is for. Will be Library Item Minified if episodeId is not null.
    /// - Note: Playlist Item Expanded - Added Attribute
    public let libraryItem: LibraryItem?
    
}

extension PlaylistItem: Decodable {}
extension PlaylistItem: Sendable {}
