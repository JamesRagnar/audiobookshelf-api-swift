//
//  GetNotificationData.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Get notification event definitions and metadata.
public struct GetNotificationData: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/api/notificationdata"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        public init() {}

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let events: [NotificationEvent]

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode)
    ]

}

public extension GetNotificationData {

    struct NotificationEvent: Decodable, Sendable {

        public let name: String

        public let requiresLibrary: Bool

        public let libraryMediaType: String?

        public let description: String

        public let descriptionKey: String

        public let variables: [String]

        public let defaults: NotificationDefaults

        public let testData: [String: String]

    }

    struct NotificationDefaults: Decodable, Sendable {

        public let title: String

        public let body: String

    }

}
