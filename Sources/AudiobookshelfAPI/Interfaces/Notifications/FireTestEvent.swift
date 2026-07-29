//
//  FireTestEvent.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Fire a global test notification event.
public struct FireTestEvent: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/api/notifications/test"

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// Fire Test Event Parameters
        ///
        /// - Parameters:
        ///   - fail: Set to true to intentionally fail the test notification.
        public init(fail: Bool = false) {
            var queryItems: [URLQueryItem] = []
            if fail {
                queryItems.append(URLQueryItem(name: "fail", value: "1"))
            }
            self.queryItems = queryItems.isEmpty ? nil : queryItems
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        /// Only admins may manage notifications.
        case forbidden

    }

    public static let responseCases: ResponseMap = [

        .code(200, .noContent),
        .code(403, .error(AudiobookshelfError.forbidden))
    ]

}
