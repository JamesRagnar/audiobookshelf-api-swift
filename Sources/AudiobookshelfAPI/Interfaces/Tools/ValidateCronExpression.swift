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

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        /// Validate Cron Expression Parameters
        ///
        /// - Parameters:
        ///   - expression: The cron expression to validate.
        public init(expression: String) throws {
            self.body = try JSONEncoder().encode(Body(expression: expression))
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let valid: Bool

        public let error: String?

    }

    public enum AudiobookshelfError: Error {

        case badRequest

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest)

    ]

}

extension ValidateCronExpression.Parameters {

    struct Body: Encodable {

        let expression: String

    }

}
