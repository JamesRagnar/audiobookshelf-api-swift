//
//  NotificationEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import RagnarSocketIO

/// A notification was fired.
public struct NotificationsUpdatedEvent: SocketEvent {

    public static let name = "notifications_updated"

    public static let defaultStreamPolicy: SocketStreamPolicy = .latest

    public typealias Schema = NotificationSettings

}
