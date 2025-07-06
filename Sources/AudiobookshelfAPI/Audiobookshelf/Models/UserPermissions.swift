//
//  UserPermissions.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct UserPermissions {
    
    /// Whether the user can download items to the server.
    public let download: Bool
    
    ///  Whether the user can update library items.
    public let update: Bool
    
    /// Whether the user can delete library items.
    public let delete: Bool
    
    /// Whether the user can upload items to the server.
    public let upload: Bool
    
    /// Whether the user can access all libraries.
    public let accessAllLibraries: Bool
    
    /// Whether the user can access all tags.
    public let accessAllTags: Bool
    
    /// Whether the user can access explicit content.
    public let accessExplicitContent: Bool
    
}

extension UserPermissions: Decodable {}
extension UserPermissions: Sendable {}
