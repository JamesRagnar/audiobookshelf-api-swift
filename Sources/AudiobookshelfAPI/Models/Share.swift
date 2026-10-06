//
//  Share.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation

/// A media item share for public access.
///
/// Note: The server model is called `MediaItemShare` and uses `toJSONForClient()`
/// which filters out sensitive fields (pash, userId, extraData) for security.
public struct Share {

    /// The ID of the share.
    public let id: String

    /// The slug used in the share URL.
    public let slug: String

    /// The type of media being shared (book or podcastEpisode).
    public let mediaItemType: String

    /// The ID of the media item being shared.
    public let mediaItemId: String

    /// ISO-8601 expiry (wire key expiresAt), 2.26.0+; missing/null means permanent.
    public let expiresAt: Date?

    /// Whether the shared media item can be downloaded.
    public let isDownloadable: Bool

    /// Required ISO-8601 creation date (wire key createdAt), 2.26.0+.
    public let createdAt: Date

    /// Required ISO-8601 update date (wire key updatedAt), 2.26.0+.
    public let updatedAt: Date

}

extension Share: Decodable {

    private enum CodingKeys: CodingKey {
        case id
        case slug
        case mediaItemType
        case mediaItemId
        case expiresAt
        case isDownloadable
        case createdAt
        case updatedAt
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        slug = try container.decode(String.self, forKey: .slug)
        mediaItemType = try container.decode(String.self, forKey: .mediaItemType)
        mediaItemId = try container.decode(String.self, forKey: .mediaItemId)
        expiresAt = try container.decodeISODateIfPresent(forKey: .expiresAt)
        isDownloadable = try container.decode(Bool.self, forKey: .isDownloadable)
        createdAt = try container.decodeISODate(forKey: .createdAt)
        updatedAt = try container.decodeISODate(forKey: .updatedAt)
    }

}
extension Share: Sendable {}
