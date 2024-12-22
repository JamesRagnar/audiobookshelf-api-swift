//
//  ClientEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-10.
//

import Foundation

/// Authenticates the socket connection.
/// Causes the server to emit the `init` or `invalid_token` event.
public struct AuthEvent: SocketEvent {
    
    public static let name = "auth"
    
    public typealias Schema = String

}

/// Cancels an in-progress library scan.
public struct CancelScanEvent: SocketEvent {
    
    public static let name = "cancel_scan"
    
    public typealias Schema = String
    
}

/// Makes the server emit log events of the given level or below to the client.
public struct SetLogListenerEvent: SocketEvent {
    
    public static let name = "set_log_listener"
    
    public typealias Schema = Int
    
}

/// Removes the client as a log listener.
public struct RemoveLogListenerEvent: SocketEvent {
    
    public static let name = "remove_log_listener"
    
    public typealias Schema = EmptyBody
    
}

/// Causes the server to emit the `daily_logs` event.
public struct FetchDailyLogsEvent: SocketEvent {
    
    public static let name = "fetch_daily_logs"
    
    public typealias Schema = EmptyBody
    
}

/// Sends a message to all users using the `admin_message` server event.
/// Admin users only.
public struct MessageAllUsersEvent: SocketEvent {
    
    public static let name = "message_all_users"
    
    public typealias Schema = Body
    
}

extension MessageAllUsersEvent {
    
    public struct Body: Codable {
        
        let message: String

    }

}

/// Causes the server to emit the `pong` event.
public struct PingEvent: SocketEvent {
    
    public static let name = "ping"
    
    public typealias Schema = EmptyBody
    
}
