//
//  Share.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation

public struct Share {

    /// The ID of the share.
    public let id: String

    /// The slug used in the share URL.
    public let slug: String

    /// The type of media being shared.
    public let mediaItemType: String?

    /// The ID of the media item being shared.
    public let mediaItemId: String?

    /// The ID of the user who created the share.
    public let userId: String

    /// The time (in ms since POSIX epoch) when the share expires. Will be null if no expiration.
    public let expiresAt: Int?

    /// The time (in ms since POSIX epoch) when the share was created.
    public let createdAt: Int

}

extension Share: Decodable {}
extension Share: Sendable {}
