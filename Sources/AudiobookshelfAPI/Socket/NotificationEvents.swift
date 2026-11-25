//
//  NotificationEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import RagnarSocketIO

/// Notification settings were updated.
/// On server 2.38.0+, delivered only to admin/root users.
public struct NotificationsUpdatedEvent: SocketEvent {

    public static let name = "notifications_updated"

    public static let defaultStreamPolicy: SocketStreamPolicy = .latest

    public typealias Schema = NotificationSettings

}
