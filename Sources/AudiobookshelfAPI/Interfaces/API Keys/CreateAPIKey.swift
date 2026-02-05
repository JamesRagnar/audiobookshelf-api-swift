//
//  CreateAPIKey.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Create a new API key for the current user.
public struct CreateAPIKey: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/api-keys"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        /// Create API Key Parameters
        ///
        /// - Parameters:
        ///   - expiresAt: Optional Unix timestamp for when the key expires.
        public init(expiresAt: Int? = nil) {
            self.body = Payload(expiresAt: expiresAt)
        }

    }

    // MARK: Response

    public typealias Response = APIKey

    public enum AudiobookshelfError: Error {

        case badRequest

        case forbidden

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        403: .failure(AudiobookshelfError.forbidden)

    ]

}

public extension CreateAPIKey.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let expiresAt: Int?

    }

}
