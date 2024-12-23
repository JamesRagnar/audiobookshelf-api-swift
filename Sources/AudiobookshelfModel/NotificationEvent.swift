//
//  NotificationEvent.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct NotificationEvent {
    
    /// The name of the notification event.
    public let name: String
    
    /// Whether the notification event depends on a library existing.
    public let requiresLibrary: Bool
    
    /// The type of media of the library the notification depends on existing. Will not exist if requiresLibrary is false.
    public let libraryMediaType: String?
    
    /// The description of the notification event.
    public let description: String
    
    /// The variables of the notification event that can be used in the notification templates.
    public let variables: [String]
    
    /// The default template for notifications using the notification event.
    public let defaults: Defaults
    
    /// The keys of the testData object will match the list of variables. The values will be the data used when sending a test notification.
    public let testData: [String: String]
    
}

extension NotificationEvent {
    
    public struct Defaults: Sendable, Decodable {
        
        /// The default title template for notifications using the notification event.
        public let title: String
        
        /// The default body template for notifications using the notification event.
        public let body: String
        
    }
    
}

extension NotificationEvent: Decodable {}
extension NotificationEvent: Sendable {}
