//
//  TestNotification.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Test a specific notification by sending a test message.
public struct TestNotification: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Test Notification Request
        ///
        /// - Parameters:
        ///   - notificationId: The ID of the notification to test.
        public init(notificationId: String) {
            self.path = "/api/notifications/\(notificationId)/test"
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case internalError

        /// Only admins may manage notifications.
        case forbidden

        /// No notification exists with the given ID.
        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound)),
            .code(500, .error(AudiobookshelfError.internalError))
        ]
    )

}
