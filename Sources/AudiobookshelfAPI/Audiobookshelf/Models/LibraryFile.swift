//
//  LibraryFile.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct LibraryFile {
    
    /// The inode of the library file.
    public let ino: String
    
    /// The metadata for the library file.
    public let metadata: FileMetadata
    
    /// The time (in ms since POSIX epoch) when the library file was added.
    public let addedAt: Int
    
    /// The time (in ms since POSIX epoch) when the library file was last updated.
    public let updatedAt: Int
    
    /// The type of file that the library file is (audio, image, etc.).
    public let fileType: String
    
}

extension LibraryFile: Decodable {}
extension LibraryFile: Sendable {}
