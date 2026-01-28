//
//  APIKey.swift
//  AudiobookshelfAPI
//
//  Created by Claude on 2026-01-28.
//

import Foundation

/// API key for authentication
public struct APIKey {

    /// Unique key identifier
    public let id: String

    /// User ID that owns this key
    public let userId: String

    /// The actual API key string
    public let key: String

    /// Optional expiration timestamp
    public let expiresAt: Int?

    /// Key creation timestamp
    public let createdAt: Int

}

extension APIKey: Decodable {}
extension APIKey: Sendable {}
