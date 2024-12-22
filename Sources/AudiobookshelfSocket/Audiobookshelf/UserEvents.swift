//
//  UserEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import AudiobookshelfModel
import Foundation

/// A user is online. (Admin Only)
public struct UserOnlineEvent: SocketEvent {
    
    public static let name = "user_online"
    
    public typealias Schema = User

}

/// A user is offline. (Admin Only)
public struct UserOfflineEvent: SocketEvent {
    
    public static let name = "user_offline"
    
    public typealias Schema = User

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
        
        /// The updated media progress.
        public let data: MediaProgress
        
    }

}

/// A user started or stopped a playback session. (Admin Only)
public struct UserStreamUpdateEvent: SocketEvent {
    
    public static let name = "user_stream_update"
    
    public typealias Schema = User

}
