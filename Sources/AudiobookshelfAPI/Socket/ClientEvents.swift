//
//  ClientEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-10.
//

import Foundation
import RagnarNetworking

/// Authenticates the socket connection.
/// Causes the server to emit the `init` or `invalid_token` event.
public struct AuthEvent: SocketOutboundEvent {
    
    public static let name = "auth"
    
    public typealias Payload = String

}

/// Cancels an in-progress library scan.
public struct CancelScanEvent: SocketOutboundEvent {
    
    public static let name = "cancel_scan"
    
    public typealias Payload = String
    
}

/// Makes the server emit log events of the given level or below to the client.
public struct SetLogListenerEvent: SocketOutboundEvent {
    
    public static let name = "set_log_listener"
    
    public typealias Payload = Int
    
}

/// Removes the client as a log listener.
public struct RemoveLogListenerEvent: SocketOutboundEvent {
    
    public static let name = "remove_log_listener"
    
    public typealias Payload = EmptyBody
    
}

/// Causes the server to emit the `daily_logs` event.
public struct FetchDailyLogsEvent: SocketOutboundEvent {
    
    public static let name = "fetch_daily_logs"
    
    public typealias Payload = EmptyBody
    
}

/// Sends a message to all users using the `admin_message` server event.
/// Admin users only.
public struct MessageAllUsersEvent: SocketOutboundEvent {
    
    public static let name = "message_all_users"
    
    public typealias Payload = Body
    
}

public extension MessageAllUsersEvent {

    struct Body: Codable, Sendable, SocketPayload {

        public let message: String

    }

}

/// Causes the server to emit the `pong` event.
public struct PingEvent: SocketOutboundEvent {
    
    public static let name = "ping"
    
    public typealias Payload = EmptyBody
    
}
