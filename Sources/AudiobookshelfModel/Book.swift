//
//  Book.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct Book {
    
    /// The ID of the library item that contains the book.
    /// - Note: Book Minified - Removed Attribute
    public let libraryItemId: String?
    
    /// The book's metadata.
    /// - Note: Book Minified - metadata is Book Metadata Minified
    /// - Note: Book Expanded - metadata is Book Metadata Expanded
    public let metadata: BookMetadata
    
    /// The absolute path on the server of the cover file. Will be null if there is no cover.
    public let coverPath: String?
    
    /// The book's tags.
    public let tags: [String]
    
    /// The book's audio files.
    /// - Note: Book Minified - Removed Attribute
    public let audioFiles: [AudioFile]?
    
    /// The book's chapters.
    /// - Note: Book Minified - Removed Attribute
    public let chapters: [BookChapter]?
    
    /// The book's ebook file. Will be null if this is an audiobook.
    /// - Note: Book Minified - Removed Attribute
    public let ebookFile: EBookFile?
    
    // MARK: Book Minified
    
    /// The number of tracks the book's audio files have.
    /// - Note: Book Minified - Added Attribute
    public let numTracks: Int?
    
    /// The number of audio files the book has.
    /// - Note: Book Minified - Added Attribute
    public let numAudioFiles: Int?
    
    /// The number of chapters the book has.
    /// - Note: Book Minified - Added Attribute
    public let numChapters: Int?
    
    // MARK: Book Minified + Expanded
    
    /// The total length (in seconds) of the book.
    /// - Note: Book Minified - Added Attribute
    /// - Note: Book Expanded - Added Attribute
    public let duration: Float?
    
    /// The total size (in bytes) of the book.
    /// - Note: Book Minified - Added Attribute
    /// - Note: Book Expanded - Added Attribute
    public let size: Int?
    
    /// The format of ebook of the book. Will be null if the book is an audiobook.
    /// - Note: Book Minified - Added Attribute
    /// - Note: Book Expanded - Added Attribute
    public let ebookFormat: String?
    
}

extension Book: Decodable {}
extension Book: Sendable {}
