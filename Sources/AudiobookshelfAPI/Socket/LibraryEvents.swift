//
//  LibraryEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import RagnarNetworking

/// A library was created.
public struct LibraryAddedEvent: SocketInboundEvent {
    
    public static let name = "library_added"
    
    public typealias Payload = Library

}

/// A library was updated.
public struct LibraryUpdatedEvent: SocketInboundEvent {
    
    public static let name = "library_updated"
    
    public typealias Payload = Library

}

/// A library was deleted.
public struct LibraryRemovedEvent: SocketInboundEvent {
    
    public static let name = "library_removed"
    
    public typealias Payload = Library

}
