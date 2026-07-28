//
//  APIKey.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation

/// API key for authentication.
///
/// The generated secret is never part of this record. It is returned exactly once, as
/// ``CreateAPIKey/CreatedAPIKey/apiKey``, and cannot be retrieved again.
public struct APIKey {

    /// User permissions structure for API keys.
    public struct Permissions {
        public let download: Bool
        public let update: Bool
        public let delete: Bool
        public let upload: Bool
        public let accessAllLibraries: Bool
        public let accessAllTags: Bool
        public let accessExplicitContent: Bool
        public let selectedTagsNotAccessible: Bool?
        public let librariesAccessible: [String]?
        public let itemTagsSelected: [String]?
    }

    /// Unique key identifier
    public let id: String

    /// User-friendly name for the API key
    public let name: String

    /// Optional description of the API key's purpose
    public let description: String?

    /// User ID that owns this key
    public let userId: String

    /// Whether the API key is currently active
    public let isActive: Bool

    /// Permissions granted to this API key
    public let permissions: Permissions

    /// Optional expiration timestamp (in ms since POSIX epoch)
    public let expiresAt: Int?

    /// Timestamp (in ms since POSIX epoch) when the key was last used
    public let lastUsedAt: Int?

    /// User ID of the admin who created this key
    public let createdByUserId: String

    /// Key creation timestamp (in ms since POSIX epoch)
    public let createdAt: Int

    /// Key last update timestamp (in ms since POSIX epoch)
    public let updatedAt: Int

}

extension APIKey: Decodable {}
extension APIKey: Sendable {}

extension APIKey.Permissions: Codable {}
extension APIKey.Permissions: Sendable {}
