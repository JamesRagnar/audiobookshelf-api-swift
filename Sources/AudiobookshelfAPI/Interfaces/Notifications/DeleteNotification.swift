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

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public typealias Body = EmptyBody

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Delete Notification Parameters
        ///
        /// - Parameters:
        ///   - notificationId: The ID of the notification to delete.
        public init(notificationId: String) {
            self.path = "/api/notifications/\(notificationId)"
        }

    }

    // MARK: Response

    public typealias Response = NotificationSettings

    public static let responseCases: ResponseCases = [

        200: .success(Response.self)

    ]

}
