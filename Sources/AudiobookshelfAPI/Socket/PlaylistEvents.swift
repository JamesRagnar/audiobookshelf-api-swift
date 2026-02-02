//
//  PlaylistEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import RagnarNetworking

/// A playlist was created.
public struct PlaylistAddedEvent: SocketInboundEvent {
    
    public static let name = "playlist_added"
    
    public typealias Payload = Playlist

}

/// A playlist was updated.
public struct PlaylistUpdatedEvent: SocketInboundEvent {
    
    public static let name = "playlist_updated"
    
    public typealias Payload = Playlist

}

/// A playlist was deleted.
public struct PlaylistRemovedEvent: SocketInboundEvent {
    
    public static let name = "playlist_removed"
    
    public typealias Payload = Playlist

}
