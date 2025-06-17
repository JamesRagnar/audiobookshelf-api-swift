//
//  Author.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct Author {
    
    /// The ID of the author.
    public let id: String
    
    /// The ASIN of the author. Will be null if unknown.
    /// - Note: Author Minified - Removed Attribute
    public let asin: String?
    
    /// The name of the author.
    public let name: String
    
    /// A description of the author. Will be null if there is none.
    /// - Note: Author Minified - Removed Attribute
    public let description: String?
    
    /// The absolute path for the author image. Will be null if there is no image.
    /// - Note: Author Minified - Removed Attribute
    public let imagePath: String?
    
    /// The time (in ms since POSIX epoch) when the author was added.
    /// - Note: Author Minified - Removed Attribute
    public let addedAt: Int?
    
    /// The time (in ms since POSIX epoch) when the author was last updated.
    /// - Note: Author Minified - Removed Attribute
    public let updatedAt: Int?
    
    // MARK: Author Expanded
    
    /// The number of books associated with the author in the library.
    /// - Note: Author Minified - Added Attribute
    public let numBooks: Int?
    
    // MARK: Author Details with Items, Series
    
    /// If `items` was requested, the library items written by the author.
    /// - Note: Author Details - Added Attribute
    public let libraryItems: [LibraryItem]?
    
    /// If `items` and `series` were requested, the series that have books written by the author.
    /// - Note: Author Details - Added Attribute
    public let series: [Series]?
    
}

extension Author: Decodable {}
extension Author: Sendable {}
