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

        public let queryItems: [String : String?]?

        public let headers: [String : String]? = nil

        public let body: RequestBody? = nil

        public let authentication: AuthenticationType = .bearer

        /// Fire Test Event Parameters
        ///
        /// - Parameters:
        ///   - fail: Set to true to intentionally fail the test notification.
        public init(fail: Bool = false) {
            var queryItems: [String: String?] = [:]
            if fail {
                queryItems["fail"] = "1"
            }
            self.queryItems = queryItems.isEmpty ? nil : queryItems
        }

    }

    // MARK: Response

    public typealias Response = Data

    public static let responseCases: ResponseCases = [

        200: .success(Response.self)

    ]

}
