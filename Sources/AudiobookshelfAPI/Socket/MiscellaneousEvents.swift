//
//  MiscellaneousEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-11.
//

import Foundation
import RagnarNetworking

/// Successfully authenticated the socket. Response to the `auth` client event.
///
/// ``ABSSocketSession`` consumes this event internally to drive its auth state. Subscribe to it
/// directly only when you need `usersOnline`.
public struct InitEvent: SocketEvent {

    public static let name = "init"

    public typealias Schema = CustomResponse

}

public extension InitEvent {

    struct CustomResponse: Decodable, Sendable {

        /// The ID of the authenticated user.
        public let userId: String

        /// The username of the authenticated user.
        public let username: String

        /// Users that are currently online. Only sent when the authenticated user is an admin.
        public let usersOnline: [PublicUser]?

    }
}

/// A single log event. Emitted after set_log_listener client event is sent. Cancelable with remove_log_listener client
/// event.
public struct LogEvent: SocketEvent {

    public static let name = "log"

    public typealias Schema = LogEventObject

}

/// A message sent by an admin user.
public struct AdminMessageEvent: SocketEvent {

    public static let name = "admin_message"

    public typealias Schema = String

}

/// Response to ping client event.
public struct PongEvent: SocketEvent {

    public static let name = "pong"

    public typealias Schema = SocketEmptyBody

}

/// A library item entered or left the metadata embedding queue. (Admin Only)
///
/// Emitted once per item: with `queued` true when the item is added to the queue, and false when it
/// leaves the queue and starts being processed.
public struct MetadataEmbedQueueUpdate: SocketEvent {

    public static let name = "metadata_embed_queue_update"

    public typealias Schema = CustomResponse

}

public extension MetadataEmbedQueueUpdate {

    struct CustomResponse: Decodable, Sendable {

        /// The ID of the library item whose queue status changed.
        public let libraryItemId: String

        /// Whether the item is now waiting in the queue.
        public let queued: Bool

    }

}

public struct LogEventObject: Decodable, Sendable {

    public enum LogName: String, Decodable, Sendable {
        case debug = "DEBUG"
        case info = "INFO"
        case warn = "WARN"
        case error = "ERROR"
    }

    public enum LogLevel: Int, Decodable, Sendable {
        case debug = 1
        case info
        case warning
        case error
    }

    /// The date and time of the log event.
    public let timestamp: String

    /// The log event's message.
    public let message: String

    /// The name of the log level
    public let levelName: LogName

    /// The log event's log level.
    public let level: LogLevel

}
