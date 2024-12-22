//
//  MiscellaneousEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-11.
//

import AudiobookshelfModel
import Foundation
import SocketIO

/// Successfully authenticated the socket. Response to auth client event.
public struct InitEvent: SocketEvent {
    
    public static let name = "init"
    
    public typealias Schema = InitEventObject

}

extension InitEvent {
    
    public struct InitEventObject: Decodable {
        
        /// The ID of the authenticated user.
        public let userId: String
        
        /// The username of the authenticated user.
        public let username: String
        
        /// The IDs of libraries currently being scanned.
        public let librariesScanning: [String]
        
        /// Users that are currently online. Will only exist when the authenticated user is an admin.
        public let usersOnline: [User]?
        
    }
}

/// An invalid token was given when authenticating. Response to auth client event.
public struct InvalidTokenEvent: SocketEvent {
    
    public static let name = "invalid_token"
    
    public typealias Schema = EmptyBody

}

/// A single log event. Emitted after set_log_listener client event is sent. Cancelable with remove_log_listener client event.
public struct LogEvent: SocketEvent {
    
    public static let name = "log"
    
    public typealias Schema = LogEventObject

}

/// The current day's log events. Response to fetch_daily_logs client event.
public struct DailyLogsEvent: SocketEvent {
    
    public static let name = "daily_logs"
    
    public typealias Schema = [LogEventObject]

}

/// A message sent by an admin user.
public struct AdminMessageEvent: SocketEvent {
    
    public static let name = "admin_message"
    
    public typealias Schema = String

}

/// Response to ping client event.
public struct PongEvent: SocketEvent {
    
    public static let name = "pong"
    
    public typealias Schema = EmptyBody

}

public struct LogEventObject: Decodable {
    
    public enum LogName: String, Decodable {
        case debug = "DEBUG"
        case info = "INFO"
        case warn = "WARN"
        case error = "ERROR"
    }
    
    public enum LogLevel: Int, Decodable {
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
