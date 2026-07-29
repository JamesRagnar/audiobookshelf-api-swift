//
//  PublicUser.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-07-27.
//

import Foundation

/// The reduced user shape the server broadcasts to admins over the socket.
///
/// This is deliberately much smaller than ``User``: it carries no permissions, progress, bookmarks
/// or library access, only enough to render an online-users list. It is the payload of
/// ``UserOnlineEvent``, ``UserOfflineEvent`` and ``UserStreamUpdateEvent``, and of the
/// `usersOnline` array on the socket init payload.
public struct PublicUser {

    /// The ID of the user.
    public let id: String

    /// The username of the user.
    public let username: String

    /// The type of the user.
    public let type: User.UserType

    /// The user's current playback session, or null when they are not listening to anything.
    public let session: PlaybackSession?

    /// The time (in ms since POSIX epoch) when the user was last seen.
    public let lastSeen: Int?

    /// The time (in ms since POSIX epoch) when the user was created.
    public let createdAt: Int

    /// The number of open socket connections for the user.
    ///
    /// Only sent on the `usersOnline` entries of the socket init payload. Null on the
    /// `user_online`, `user_offline` and `user_stream_update` events.
    public let connections: Int?

}

extension PublicUser: Decodable {}
extension PublicUser: Sendable {}
