//
//  Collection.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct Collection {
    
    /// The ID of the collection.
    public let id: String
    
    /// The ID of the library the collection belongs to.
    public let libraryId: String
    
    /// The ID of the user that created the collection.
    public let userId: String?
    
    /// The name of the collection.
    public let name: String
    
    /// The collection's description. Will be null if there is none.
    public let description: String?
    
    /// The books that belong to the collection.
    /// - Note: Collection Expanded - books is array of Library Item Expanded
    public let books: [LibraryItem]
    
    /// The time (in ms since POSIX epoch) when the collection was last updated.
    public let lastUpdate: Int
    
    /// The time (in ms since POSIX epoch) when the collection was created.
    public let createdAt: Int
    
    // MARK: Collection + rssfeed
    
    /// The collection's currently open RSS feed. Will be null if the collection does not have an open RSS feed.
    /// - Note: Collection rssfeed - Added Attribute
    public let rssFeed: RSSFeed?
    
}

extension Collection: Decodable {}
extension Collection: Sendable {}
