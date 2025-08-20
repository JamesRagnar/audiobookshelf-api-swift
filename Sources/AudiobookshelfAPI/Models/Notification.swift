//
//  Notification.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct Notification {
    
    /// The ID of the notification.
    public let id: String
    
    /// The ID of the library the notification is associated with.
    public let libraryId: String?
    
    /// The name of the event the notification will fire on.
    public let eventName: String
    
    /// The Apprise URLs to use for the notification.
    public let urls: [String]
    
    /// The template for the notification title.
    public let titleTemplate: String
    
    /// The template for the notification body.
    public let bodyTemplate: String
    
    /// Whether the notification is enabled.
    public let enabled: Bool
    
    /// The notification's type.
    public let type: String
    
    /// The time (in ms since POSIX epoch) when the notification was last fired. Will be null if the notification has not fired.
    public let lastFiredAt: Int?
    
    /// Whether the last notification attempt failed.
    public let lastAttemptFailed: Bool
    
    /// The number of consecutive times the notification has failed.
    public let numConsecutiveFailedAttempts: Int
    
    /// The number of times the notification has fired.
    public let numTimesFired: Int
    
    /// The time (in ms since POSIX epoch) when the notification was created.
    public let createdAt: Int
    
}

extension Notification: Decodable {}
extension Notification: Sendable {}
