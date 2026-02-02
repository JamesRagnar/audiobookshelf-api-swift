//
//  CollectionEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import RagnarNetworking

/// A collection was created.
public struct CollectionAddedEvent: SocketInboundEvent {
    
    public static let name = "collection_added"
    
    public typealias Payload = Collection

}

/// A collection was updated.
public struct CollectionUpdatedEvent: SocketInboundEvent {
    
    public static let name = "collection_updated"
    
    public typealias Payload = Collection

}

/// A collection was deleted.
public struct CollectionRemovedEvent: SocketInboundEvent {
    
    public static let name = "collection_removed"
    
    public typealias Payload = Collection

}
