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

    /// The time (in ms since POSIX epoch) when the share expires. Will be null if no expiration.
    public let expiresAt: Int?

    /// Whether the shared media item can be downloaded.
    public let isDownloadable: Bool

    /// The time (in ms since POSIX epoch) when the share was created.
    public let createdAt: Int

    /// The time (in ms since POSIX epoch) when the share was last updated.
    public let updatedAt: Int

}

extension Share: Decodable {}
extension Share: Sendable {}
