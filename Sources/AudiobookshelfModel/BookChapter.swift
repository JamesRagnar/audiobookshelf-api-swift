//
//  BookChapter.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct BookChapter {
    
    /// The ID of the book chapter.
    public let id: Int
    
    /// When in the book (in seconds) the chapter starts.
    public let start: Float
    
    /// When in the book (in seconds) the chapter ends.
    public let end: Float
    
    /// The title of the chapter.
    public let title: String
    
}

extension BookChapter: Decodable {}
extension BookChapter: Sendable {}
