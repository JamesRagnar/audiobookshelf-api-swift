//
//  LibraryItemEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import AudiobookshelfModel
import Foundation

/// A library item was created.
public struct ItemAddedEvent: SocketEvent {
    
    public static let name = "item_added"
    
    public typealias Schema = LibraryItem

}

/// A library item was updated.
public struct ItemUpdatedEvent: SocketEvent {
    
    public static let name = "item_updated"
    
    public typealias Schema = LibraryItem

}

/// A library item was deleted.
public struct ItemRemovedEvent: SocketEvent {
    
    public static let name = "item_removed"
    
    public typealias Schema = LibraryItem

}

/// Library items were created.
public struct ItemsAddedEvent: SocketEvent {
    
    public static let name = "items_added"
    
    public typealias Schema = [LibraryItem]

}

/// Library items were updated.
public struct ItemsUpdatedEvent: SocketEvent {
    
    public static let name = "items_updated"
    
    public typealias Schema = [LibraryItem]

}

/// Batch library item quick matching is complete.
public struct BatchQuickMatchCompleteEvent: SocketEvent {
    
    public static let name = "batch_quickmatch_complete"
    
    public typealias Schema = BatchQuickMatchResult

}

extension BatchQuickMatchCompleteEvent {
    
    public struct BatchQuickMatchResult: Decodable {
        
        /// Whether library items were successfully updated.
        public let success: Bool
        
        /// The number of library items that were updated.
        public let updates: Int
        
        /// The number of library items that a match could not be found for.
        public let unmatched: Int

    }
    
}
