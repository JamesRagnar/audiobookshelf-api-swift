//
//  Folder.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct Folder {
    
    /// The ID of the folder. (Read Only)
    public let id: String
    
    /// The path on the server for the folder. (Read Only)
    public let fullPath: String
    
    /// The ID of the library the folder belongs to. (Read Only)
    public let libraryId: String
    
    /// The time (in ms since POSIX epoch) when the folder was added. (Read Only)
    public let addedAt: Int
    
}

extension Folder: Decodable {}
extension Folder: Sendable {}
