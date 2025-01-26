//
//  Library.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct Library {
    
    /// The ID of the library. (Read Only)
    public let id: String
    
    /// The name of the library.
    public let name: String
    
    /// The folders that the library is composed of on the server.
    public let folders: [Folder]
    
    /// Display position of the library in the list of libraries. Must be >= 1.
    public let displayOrder: Int
    
    /// The selected icon for the library. See Library Icons for a list of possible icons.
    public let icon: Icon
    
    /// The type of media that the library contains. Will be book or podcast. (Read Only)
    public let mediaType: MediaType
    
    /// Preferred metadata provider for the library. See Metadata Providers for a list of possible providers.
    public let provider: String
    
    /// The settings for the library.
    public let settings: LibrarySettings
    
    /// The time (in ms since POSIX epoch) when the library was created. (Read Only)
    public let createdAt: Int

    /// The time (in ms since POSIX epoch) when the library was last updated. (Read Only)
    public let lastUpdate: Int
    
}

public extension Library {
    
    enum MediaType: String, Decodable, Sendable {
        
        case book
        
        case podcast
        
    }

}

extension Library: Decodable {}
extension Library: Sendable {}
