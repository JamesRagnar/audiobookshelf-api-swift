//
//  RSSFeedMetadata.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct RSSFeedMetadata {
    
    /// The title of the entity the RSS feed is for.
    public let title: String
    
    /// The description of the entity the RSS feed is for.
    public let description: String?
    
    /// The author of the entity the RSS feed is for.
    /// - Note: RSS Feed Metadata Minified - Removed Attribute
    public let author: String?
    
    /// The URL of the RSS feed's image.
    /// - Note: RSS Feed Metadata Minified - Removed Attribute
    public let imageUrl: String?
    
    /// The URL of the RSS feed.
    /// - Note: RSS Feed Metadata Minified - Removed Attribute
    public let feedUrl: String?
    
    /// The URL of the entity the RSS feed is for.
    /// - Note: RSS Feed Metadata Minified - Removed Attribute
    public let link: String?
    
    /// Whether the RSS feed's contents are explicit.
    /// - Note: RSS Feed Metadata Minified - Removed Attribute
    public let explicit: Bool?
    
    /// The type of the RSS feed.
    /// - Note: RSS Feed Metadata Minified - Removed Attribute
    public let type: String?
    
    /// The language of the RSS feed.
    /// Note: RSS Feed Metadata Minified - Removed Attribute
    public let language: String?
    
    /// Whether the RSS feed is marked to prevent indexing of the feed.
    public let preventIndexing: Bool
    
    /// The owner name of the RSS feed.
    public let ownerName: String?
    
    ///  The owner email of the RSS feed.
    public let ownerEmail: String?
    
}

extension RSSFeedMetadata: Decodable {}
extension RSSFeedMetadata: Sendable {}
