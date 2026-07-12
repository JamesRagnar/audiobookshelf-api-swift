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

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/validate-cron"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationType = .bearer

        /// Validate Cron Expression Parameters
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

    public static let responseCases: ResponseMap = [

        .code(200, .noContent),
        .code(400, .error(AudiobookshelfError.badRequest))
    ]

}

public extension ValidateCronExpression.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let expression: String

    }

}
