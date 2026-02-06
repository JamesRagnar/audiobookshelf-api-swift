//
//  CreateNotification.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Create a new notification.
public struct CreateNotification: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/notifications"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        public init(
            eventName: String,
            urls: [String],
            titleTemplate: String,
            bodyTemplate: String,
            libraryId: String? = nil,
            enabled: Bool = true
        ) {
            self.body = Payload(
                eventName: eventName,
                urls: urls,
                titleTemplate: titleTemplate,
                bodyTemplate: bodyTemplate,
                libraryId: libraryId,
                enabled: enabled
            )
        }

    }

    // MARK: Response

    public typealias Response = NotificationSettings

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

public extension CreateNotification.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let eventName: String

        let urls: [String]

        let titleTemplate: String

        let bodyTemplate: String

        let libraryId: String?

        let enabled: Bool

    }

}
