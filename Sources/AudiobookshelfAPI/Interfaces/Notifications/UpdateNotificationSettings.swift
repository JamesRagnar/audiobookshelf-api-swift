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

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public let body: RequestBody?

        public let authentication: AuthenticationType = .bearer

        public init(
            appriseApiUrl: String? = nil,
            maxFailedAttempts: Int? = nil,
            maxNotificationQueue: Int? = nil,
            notificationDelay: Int? = nil
        ) {
            self.body = .json(
                Body(
                    appriseApiUrl: appriseApiUrl,
                    maxFailedAttempts: maxFailedAttempts,
                    maxNotificationQueue: maxNotificationQueue,
                    notificationDelay: notificationDelay
                )
            )
        }

    }

    // MARK: Response

    public typealias Response = NotificationSettings

    public enum AudiobookshelfError: Error {

        case badRequest

        case forbidden

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        403: .failure(AudiobookshelfError.forbidden),

    ]

}

public extension UpdateNotificationSettings.Parameters {

    struct Body: Encodable, Sendable {

        let appriseApiUrl: String?

        let maxFailedAttempts: Int?

        let maxNotificationQueue: Int?

        let notificationDelay: Int?

    }

}
