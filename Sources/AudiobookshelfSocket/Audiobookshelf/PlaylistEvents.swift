//
//  PlaylistEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import AudiobookshelfModel

/// A playlist was created.
public struct PlaylistAddedEvent: SocketEvent {
    
    public static let name = "playlist_added"
    
    public typealias Schema = Playlist

}

/// A playlist was updated.
public struct PlaylistUpdatedEvent: SocketEvent {
    
    public static let name = "playlist_updated"
    
    public typealias Schema = Playlist

}

/// A playlist was deleted.
public struct PlaylistRemovedEvent: SocketEvent {
    
    public static let name = "playlist_removed"
    
    public typealias Schema = Playlist

}
