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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .patch

        public let path: String = "/api/notifications"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Sends all three effective settings on 2.26.0+; preservation requires current values.
        public init(replacement: Replacement) {
            self.body = Payload(
                appriseApiUrl: replacement.appriseApiUrl,
                maxFailedAttempts: replacement.maxFailedAttempts,
                maxNotificationQueue: replacement.maxNotificationQueue,
                notificationDelay: nil,
                replacement: true
            )
        }

        /// Legacy partial write on 2.26.0+: omitted/null/empty URL clears it;
        /// omitted/null retry and queue limits reset to 5 and 20. notificationDelay is ignored
        /// but explicitly supplied values remain encoded.
        @available(*, deprecated, message: "Use Request(replacement:); omitted values reset settings.")
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
                notificationDelay: notificationDelay,
                replacement: false
            )
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden))
        ]
    )

}

public extension UpdateNotificationSettings.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let appriseApiUrl: String?

        let maxFailedAttempts: Int?

        let maxNotificationQueue: Int?

        let notificationDelay: Int?

        let replacement: Bool

        private enum CodingKeys: CodingKey {
            case appriseApiUrl, maxFailedAttempts, maxNotificationQueue, notificationDelay
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            if replacement {
                try container.encode(appriseApiUrl, forKey: .appriseApiUrl)
            } else {
                try container.encodeIfPresent(appriseApiUrl, forKey: .appriseApiUrl)
            }
            try container.encodeIfPresent(maxFailedAttempts, forKey: .maxFailedAttempts)
            try container.encodeIfPresent(maxNotificationQueue, forKey: .maxNotificationQueue)
            try container.encodeIfPresent(notificationDelay, forKey: .notificationDelay)
        }

    }

}

public extension UpdateNotificationSettings {

    /// Complete effective settings replacement on 2.26.0+.
    struct Replacement: Encodable, Sendable {
        /// Wire appriseApiUrl; explicit null clears, string sets.
        public let appriseApiUrl: String?
        /// Required wire retry limit; always sent.
        public let maxFailedAttempts: Int
        /// Required wire queue limit; always sent.
        public let maxNotificationQueue: Int

        /// All arguments are required; pass current values to preserve settings.
        /// - Parameters:
        ///   - appriseApiUrl: Wire URL, explicitly encoded as null to clear or String to set.
        ///   - maxFailedAttempts: Desired wire retry limit, always transmitted.
        ///   - maxNotificationQueue: Desired wire queue limit, always transmitted.
        public init(appriseApiUrl: String?, maxFailedAttempts: Int, maxNotificationQueue: Int) {
            self.appriseApiUrl = appriseApiUrl
            self.maxFailedAttempts = maxFailedAttempts
            self.maxNotificationQueue = maxNotificationQueue
        }

        private enum CodingKeys: CodingKey {
            case appriseApiUrl, maxFailedAttempts, maxNotificationQueue
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(appriseApiUrl, forKey: .appriseApiUrl)
            try container.encode(maxFailedAttempts, forKey: .maxFailedAttempts)
            try container.encode(maxNotificationQueue, forKey: .maxNotificationQueue)
        }
    }

}
