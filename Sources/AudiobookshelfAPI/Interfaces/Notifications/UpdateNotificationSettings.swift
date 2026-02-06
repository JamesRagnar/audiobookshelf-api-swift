//
//  UpdateNotificationSettings.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Update notification settings.
public struct UpdateNotificationSettings: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String = "/api/notifications"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        public init(
            appriseApiUrl: String? = nil,
            maxFailedAttempts: Int? = nil,
            maxNotificationQueue: Int? = nil,
            notificationDelay: Int? = nil
        ) {
            self.body = Payload(
                appriseApiUrl: appriseApiUrl,
                maxFailedAttempts: maxFailedAttempts,
                maxNotificationQueue: maxNotificationQueue,
                notificationDelay: notificationDelay
            )
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden)),
    ]

}

public extension UpdateNotificationSettings.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let appriseApiUrl: String?

        let maxFailedAttempts: Int?

        let maxNotificationQueue: Int?

        let notificationDelay: Int?

    }

}
