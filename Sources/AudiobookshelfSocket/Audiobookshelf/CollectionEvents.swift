//
//  CollectionEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import AudiobookshelfModel
import Foundation

/// A collection was created.
public struct CollectionAddedEvent: SocketEvent {
    
    public static let name = "collection_added"
    
    public typealias Schema = Collection

}

/// A collection was updated.
public struct CollectionUpdatedEvent: SocketEvent {
    
    public static let name = "collection_updated"
    
    public typealias Schema = Collection

}

/// A collection was deleted.
public struct CollectionRemovedEvent: SocketEvent {
    
    public static let name = "collection_removed"
    
    public typealias Schema = Collection

}
