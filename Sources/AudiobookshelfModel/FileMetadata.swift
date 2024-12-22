//
//  FileMetadata.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct FileMetadata {
    
    /// The filename of the file.
    public let filename: String
    
    /// The file extension of the file.
    public let ext: String
    
    /// The absolute path on the server of the file.
    public let path: String
    
    /// The path of the file, relative to the book's or podcast's folder.
    public let relPath: String
    
    /// The size (in bytes) of the file.
    public let size: Int
    
    /// The time (in ms since POSIX epoch) when the file was last modified on disk.
    public let mtimeMs: Int
    
    /// The time (in ms since POSIX epoch) when the file status was changed on disk.
    public let ctimeMs: Int
    
    /// The time (in ms since POSIX epoch) when the file was created on disk. Will be 0 if unknown.
    public let birthtimeMs: Int
    
}

extension FileMetadata: Decodable {}
extension FileMetadata: Sendable {}
