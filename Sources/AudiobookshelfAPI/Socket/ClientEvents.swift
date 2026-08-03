//
//  ClientEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-10.
//

import Foundation
import RagnarSocketIO

/// Authenticates the socket connection.
/// Causes the server to emit the `init` event on success or the `auth_failed` event on failure.
public struct AuthEvent: EmittableSocketEvent {

    public static let name = "auth"

    public typealias Schema = String

}

/// Cancels an in-progress library scan.
public struct CancelScanEvent: EmittableSocketEvent {

    public static let name = "cancel_scan"

    public typealias Schema = String

}

/// Makes the server emit log events of the given level or below to the client.
public struct SetLogListenerEvent: EmittableSocketEvent {

    public static let name = "set_log_listener"

    public typealias Schema = Int

}

/// Removes the client as a log listener.
public struct RemoveLogListenerEvent: EmittableSocketEvent {

    public static let name = "remove_log_listener"

    public typealias Schema = SocketEmptyBody

}

/// Sends a message to all users using the `admin_message` server event.
/// Admin users only.
public struct MessageAllUsersEvent: EmittableSocketEvent {

    public static let name = "message_all_users"

    public typealias Schema = Body

}

public extension MessageAllUsersEvent {

    struct Body: Codable, Sendable {

        public let message: String

        public init(message: String) {
            self.message = message
        }

    }

}

/// Causes the server to emit the `pong` event.
public struct PingEvent: EmittableSocketEvent {

    public static let name = "ping"

    public typealias Schema = SocketEmptyBody

}

/// Starts a streamed cover search.
public struct SearchCoversEvent: EmittableSocketEvent {

    public static let name = "search_covers"

    public typealias Schema = Body

}

public extension SearchCoversEvent {

    struct Body: Codable, Sendable {

        public let requestId: String
        public let title: String
        public let author: String
        public let provider: String
        public let podcast: Bool

        public init(
            requestId: String,
            title: String,
            author: String,
            provider: String,
            podcast: Bool
        ) {
            self.requestId = requestId
            self.title = title
            self.author = author
            self.provider = provider
            self.podcast = podcast
        }

    }
}

/// Cancels a streamed cover search.
public struct CancelCoverSearchEvent: EmittableSocketEvent {

    public static let name = "cancel_cover_search"

    public typealias Schema = String

}
