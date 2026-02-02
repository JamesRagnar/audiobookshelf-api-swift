//
//  NotificationEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import RagnarNetworking

/// A notification was fired.
public struct NotificationsUpdatedEvent: SocketInboundEvent {
    
    public static let name = "notifications_updated"
    
    public typealias Payload = NotificationSettings

}
