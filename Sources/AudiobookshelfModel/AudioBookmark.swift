//
//  AudioBookmark.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct AudioBookmark {
    
    /// The ID of the library item the bookmark is for.
    public let libraryItemId: String
    
    /// The title of the bookmark.
    public let title: String
    
    /// The time (in seconds) the bookmark is at in the book.
    public let time: Int
    
    /// The time (in ms since POSIX epoch) when the bookmark was created.
    public let createdAt: Int
    
}

extension AudioBookmark: Decodable {}
extension AudioBookmark: Sendable {}
