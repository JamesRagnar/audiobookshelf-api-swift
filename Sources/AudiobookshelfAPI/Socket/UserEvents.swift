//
//  UserEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import RagnarNetworking

/// A user is online. (Admin Only)
///
/// - Note: The server sends the reduced ``PublicUser`` shape here, not the full ``User``.
public struct UserOnlineEvent: SocketEvent {

    public static let name = "user_online"

    public typealias Schema = PublicUser

}

/// A user is offline. (Admin Only)
///
/// - Note: The server sends the reduced ``PublicUser`` shape here, not the full ``User``.
public struct UserOfflineEvent: SocketEvent {

    public static let name = "user_offline"

    public typealias Schema = PublicUser

}

/// A user was created. (Admin Only)
public struct UserAddedEvent: SocketEvent {

    public static let name = "user_added"

    public typealias Schema = User

}

/// The authenticated user has been updated.
public struct UserUpdatedEvent: SocketEvent {

    public static let name = "user_updated"

    public typealias Schema = User

}

/// A user was deleted. (Admin Only)
public struct UserRemovedEvent: SocketEvent {

    public static let name = "user_removed"

    public typealias Schema = User

}

/// One of the authenticated user's media progress was created/updated.
public struct UserItemProgressUpdated: SocketEvent {

    public static let name = "user_item_progress_updated"

    public typealias Schema = Body

}

extension UserItemProgressUpdated {

    public struct Body: Decodable, Sendable {

        /// The ID of the updated media progress.
        public let id: String

        /// The ID of the playback session that drove the update.
        public let sessionId: String?

        /// A human-readable description of the device the session is playing on.
        public let deviceDescription: String?

        /// The updated media progress.
        public let data: MediaProgress

    }

}

/// A user started or stopped a playback session. (Admin Only)
///
/// - Note: The server sends the reduced ``PublicUser`` shape here, not the full ``User``. Read
///   ``PublicUser/session`` to see what they are listening to.
public struct UserStreamUpdateEvent: SocketEvent {

    public static let name = "user_stream_update"

    public typealias Schema = PublicUser

}

/// A user's playback session was closed.
public struct UserSessionClosedEvent: SocketEvent {

    public static let name = "user_session_closed"

    public typealias Schema = String

}
