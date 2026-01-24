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

    /// The email address of the user. Will be null if not set.
    public let email: String?

    /// Whether the user has an OpenID link. Will be null if not applicable.
    public let hasOpenIDLink: Bool?

    /// The type of the user.
    /// There will be only one root user which is created when the server first starts.
    public let type: UserType
    
    /// The authentication token of the user.
    @available(
        *,
         deprecated,
         message: "User.token will be removed in a future server version, no earlier than September 30, 2025. Please migrate to the new JWT authentication flow."
    )
    public let token: String
    
    /// JWT access token.
    public let accessToken: String
    
    /// JWT refresh token.
    public let refreshToken: String?
    
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
    public let lastSeen: Int?
    
    /// The time (in ms since POSIX epoch) when the user was created.
    public let createdAt: Int
    
    /// The user's permissions.
    public let permissions: UserPermissions
    
    /// The IDs of libraries accessible to the user. An empty array means all libraries are accessible.
    public let librariesAccessible: [String]
    
    /// The tags accessible to the user. An empty array means all tags are accessible.
    public let itemTagsSelected: [String]?
    
}

extension User {
    
    public enum UserType: String, Decodable, Sendable {
        
        case root
        
        case guest
        
        case user
        
        case admin
        
    }
}

extension User: Sendable {}

extension User: Decodable {

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case hasOpenIDLink
        case type
        case token
        case accessToken
        case refreshToken
        case mediaProgress
        case seriesHideFromContinueListening
        case bookmarks
        case isActive
        case isLocked
        case lastSeen
        case createdAt
        case permissions
        case librariesAccessible
        case itemTagsSelected
    }

}

