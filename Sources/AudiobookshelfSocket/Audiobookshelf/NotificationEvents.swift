//
//  NotificationEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import AudiobookshelfModel
import Foundation

/// A notification was fired.
public struct NotificationsUpdatedEvent: SocketEvent {
    
    public static let name = "notifications_updated"
    
    public typealias Schema = NotificationSettings

}
