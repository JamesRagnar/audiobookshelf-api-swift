//
//  ValidateCronExpression.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Validate a cron expression for scheduled tasks.
public struct ValidateCronExpression: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String = "/api/validate-cron"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Validate Cron Expression Request
        ///
        /// - Parameters:
        ///   - expression: The cron expression to validate.
        public init(expression: String) {
            self.body = Payload(expression: expression)
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest))
        ]
    )

}

public extension ValidateCronExpression.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let expression: String

    }

}
