//
//  RSSFeed.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct RSSFeed {
    
    /// The ID of the RSS feed.
    public let id: UUID
    
    /// The slug (the last part of the URL) for the RSS feed.
    /// - Note: RSS Feed Minified - Removed Attribute
    public let slug: String?

    /// The ID of the user that created the RSS feed.
    /// - Note: RSS Feed Minified - Removed Attribute
    public let userId: UUID?

    /// The type of entity the RSS feed is for.
    public let entityType: String

    /// The ID of the entity the RSS feed is for.
    public let entityId: UUID

    /// The path of the cover to use for the RSS feed.
    /// - Note: RSS Feed Minified - Removed Attribute
    public let coverPath: String?

    /// The server's address.
    /// - Note: RSS Feed Minified - Removed Attribute
    public let serverAddress: String?

    /// The full URL of the RSS feed.
    public let feedUrl: String

    /// The RSS feed's metadata.
    /// - Note: RSS Feed Minified - RSS Feed Metadata Minified
    public let meta: RSSFeedMetadata

    /// The RSS feed's episodes.
    /// - Note: RSS Feed Minified - Removed Attribute
    public let episodes: [RSSFeedEpisode]?

    /// The time (in ms since POSIX epoch) when the RSS feed was created.
    /// - Note: RSS Feed Minified - Removed Attribute
    public let createdAt: Int?

    /// The time (in ms since POSIX epoch) when the RSS feed was last updated.
    /// - Note: RSS Feed Minified - Removed Attribute
    public let updatedAt: Int?

    /// The time (in ms since POSIX epoch) when the entity (library item, collection, etc.) was last updated.
    public let entityUpdatedAt: Int?

}

extension RSSFeed: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, slug, userId, entityType, entityId, coverPath, serverAddress, feedUrl, meta, episodes, createdAt, updatedAt, entityUpdatedAt
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Required fields (always present)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.entityType = try container.decode(String.self, forKey: .entityType)
        self.entityId = try container.decode(UUID.self, forKey: .entityId)
        self.feedUrl = try container.decode(String.self, forKey: .feedUrl)
        self.meta = try container.decode(RSSFeedMetadata.self, forKey: .meta)

        // Optional fields (removed in minified scope)
        self.slug = try container.decodeIfPresent(String.self, forKey: .slug)
        self.userId = try container.decodeIfPresent(UUID.self, forKey: .userId)
        self.coverPath = try container.decodeIfPresent(String.self, forKey: .coverPath)
        self.serverAddress = try container.decodeIfPresent(String.self, forKey: .serverAddress)
        self.episodes = try container.decodeIfPresent([RSSFeedEpisode].self, forKey: .episodes)
        self.createdAt = try container.decodeIfPresent(Int.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(Int.self, forKey: .updatedAt)
        self.entityUpdatedAt = try container.decodeIfPresent(Int.self, forKey: .entityUpdatedAt)
    }
}

extension RSSFeed: Sendable {}
