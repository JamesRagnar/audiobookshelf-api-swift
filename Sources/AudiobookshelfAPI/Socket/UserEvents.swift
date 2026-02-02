//
//  UserEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import RagnarNetworking

/// A user is online. (Admin Only)
public struct UserOnlineEvent: SocketInboundEvent {
    
    public static let name = "user_online"
    
    public typealias Payload = User

}

/// A user is offline. (Admin Only)
public struct UserOfflineEvent: SocketInboundEvent {
    
    public static let name = "user_offline"
    
    public typealias Payload = User

}

/// A user was created. (Admin Only)
public struct UserAddedEvent: SocketInboundEvent {
    
    public static let name = "user_added"
    
    public typealias Payload = User

}

/// The authenticated user has been updated.
public struct UserUpdatedEvent: SocketInboundEvent {
    
    public static let name = "user_updated"
    
    public typealias Payload = User

}

/// A user was deleted. (Admin Only)
public struct UserRemovedEvent: SocketInboundEvent {
    
    public static let name = "user_removed"
    
    public typealias Payload = User

}

/// One of the authenticated user's media progress was created/updated.
public struct UserItemProgressUpdated: SocketInboundEvent {
    
    public static let name = "user_item_progress_updated"
    
    public typealias Payload = Body
    
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
public struct UserStreamUpdateEvent: SocketInboundEvent {

    public static let name = "user_stream_update"

    public typealias Payload = User

}

/// A user's playback session was closed.
public struct UserSessionClosedEvent: SocketInboundEvent {

    public static let name = "user_session_closed"

    public typealias Payload = String

}
