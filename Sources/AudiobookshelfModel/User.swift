//
//  User.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct User {
    
    /// The ID of the user. Only the root user has the root ID.
    public let id: String
    
    /// The username of the user.
    public let username: String
    
    /// The type of the user. Will be root, guest, user, or admin. There will be only one root user which is created when the server first starts.
    public let type: String
    
    /// The authentication token of the user.
    public let token: String
    
    /// The user's media progress.
    public let mediaProgress: [MediaProgress]
    
    /// The IDs of series to hide from the user's "Continue Series" shelf.
    public let seriesHideFromContinueListening: [String]
    
    /// The user's bookmarks.
    public let bookmarks: [AudioBookmark]
    
    /// Whether the user's account is active.
    public let isActive: Bool
    
    /// Whether the user is locked.
    public let isLocked: Bool
    
    /// The time (in ms since POSIX epoch) when the user was last seen by the server. Will be null if the user has never logged in.
    public  let lastSeen: Int?
    
    /// The time (in ms since POSIX epoch) when the user was created.
    public let createdAt: Int
    
    /// The user's permissions.
    public let permissions: UserPermissions
    
    /// The IDs of libraries accessible to the user. An empty array means all libraries are accessible.
    public let librariesAccessible: [String]
    
    /// The tags accessible to the user. An empty array means all tags are accessible.
    public let itemTagsAccessible: [String]?
    
}

extension User: Decodable {}
extension User: Sendable {}
