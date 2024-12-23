//
//  NotificationSettings.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct NotificationSettings {
    
    public enum AppriseType: String, Sendable, Decodable {
        case api
    }
    
    /// The ID of the notification settings.
    public let id: String
    
    /// The type of Apprise that will be used.
    public let appriseType: AppriseType
    
    ///  The full URL where the Apprise API to use is located.
    public let appriseApiUrl: String?
    
    /// The set notifications.
    public let notifications: [Notification]
    
    /// The maximum number of times a notification fails before being disabled.
    public let maxFailedAttempts: Int
    
    /// The maximum number of notifications in the notification queue before events are ignored.
    public let maxNotificationQueue: Int
    
    /// The time (in ms) between notification pushes.
    public let notificationDelay: Int
    
}

extension NotificationSettings: Decodable {}
extension NotificationSettings: Sendable {}
