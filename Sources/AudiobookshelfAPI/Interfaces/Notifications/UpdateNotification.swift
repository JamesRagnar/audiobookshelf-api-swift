//
//  UpdateNotification.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Update a notification.
public struct UpdateNotification: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        /// Update Notification Parameters
        ///
        /// - Parameters:
        ///   - notificationId: The ID of the notification to update.
        ///   - libraryId: Optional library ID scope.
        ///   - eventName: The event name.
        ///   - urls: Array of Apprise notification URLs.
        ///   - titleTemplate: Title template with {{variable}} support.
        ///   - bodyTemplate: Body template with {{variable}} support.
        ///   - enabled: Whether the notification is enabled.
        ///   - type: Notification type.
        public init(
            notificationId: String,
            libraryId: String? = nil,
            eventName: String,
            urls: [String],
            titleTemplate: String,
            bodyTemplate: String,
            enabled: Bool,
            type: String? = nil
        ) {
            self.path = "/api/notifications/\(notificationId)"
            self.body = Payload(
                id: notificationId,
                libraryId: libraryId,
                eventName: eventName,
                urls: urls,
                titleTemplate: titleTemplate,
                bodyTemplate: bodyTemplate,
                enabled: enabled,
                type: type
            )
        }

    }

    // MARK: Response

    public typealias Response = NotificationSettings

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
    ]

}

public extension UpdateNotification.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let id: String

        let libraryId: String?

        let eventName: String

        let urls: [String]

        let titleTemplate: String

        let bodyTemplate: String

        let enabled: Bool

        let type: String?

    }

}
