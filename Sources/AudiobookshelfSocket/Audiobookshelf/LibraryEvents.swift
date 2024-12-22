//
//  LibraryEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import AudiobookshelfModel
import Foundation

/// A library was created.
public struct LibraryAddedEvent: SocketEvent {
    
    public static let name = "library_added"
    
    public typealias Schema = Library

}

/// A library was updated.
public struct LibraryUpdatedEvent: SocketEvent {
    
    public static let name = "library_updated"
    
    public typealias Schema = Library

}

/// A library was deleted.
public struct LibraryRemovedEvent: SocketEvent {
    
    public static let name = "library_removed"
    
    public typealias Schema = Library

}
