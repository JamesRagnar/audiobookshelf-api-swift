//
//  DeleteNotification.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Delete a notification.
public struct DeleteNotification: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Delete Notification Request
        ///
        /// - Parameters:
        ///   - notificationId: The ID of the notification to delete.
        public init(notificationId: String) {
            self.path = "/api/notifications/\(notificationId)"
        }

    }

    // MARK: Response

    public typealias Response = NotificationSettings

    public enum AudiobookshelfError: Error, Sendable {

        /// Only admins may manage notifications.
        case forbidden

        /// No notification exists with the given ID.
        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}
