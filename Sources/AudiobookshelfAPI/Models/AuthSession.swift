//
//  AuthSession.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-07-27.
//

import Foundation

/// An active authentication session, representing one refresh token issued to one device.
///
/// This is unrelated to `PlaybackSession`, which tracks listening activity. An auth session is the
/// server-side record backing a refresh token, and deleting one logs that device out.
///
/// - Note: Requires server `>= 2.36.0`.
public struct AuthSession {

    /// The ID of the auth session.
    public let id: String

    /// The IP address the session was last used from. Null if the server did not record one.
    public let ipAddress: String?

    /// The raw user agent string the session was last used from. Null if the client sent none.
    public let userAgent: String?

    /// The `userAgent` parsed into display-friendly components.
    ///
    /// Null when there was no user agent, or when nothing could be parsed from it.
    public let deviceInfo: AuthSessionDeviceInfo?

    /// The time (in ms since POSIX epoch) when the session was created.
    public let createdAt: Int?

    /// The time (in ms since POSIX epoch) when the session was last refreshed.
    public let updatedAt: Int?

    /// Whether this session is the one the request was made with.
    ///
    /// The server matches on both the current and the previous (grace period) refresh token, so this
    /// stays true across a token rotation.
    public let current: Bool

}

extension AuthSession: Decodable {}
extension AuthSession: Sendable {}
