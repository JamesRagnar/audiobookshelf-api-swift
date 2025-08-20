//
//  EBookFile.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct EBookFile {
    
    /// The inode of the ebook file.
    public let ino: String
    
    /// The metadata of the ebook file.
    public let metadata: FileMetadata
    
    /// The ebook format of the ebook file.
    public let ebookFormat: String
    
    /// The time (in ms since POSIX epoch) when the library file was added.
    public let addedAt: Int
    
    /// The time (in ms since POSIX epoch) when the library file was last updated.
    public let updatedAt: Int
    
}

extension EBookFile: Decodable {}
extension EBookFile: Sendable {}
