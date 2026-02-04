//
//  UpdateAPIKey.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Update an API key's expiration time.
public struct UpdateAPIKey: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public let body: RequestBody?

        public let authentication: AuthenticationType = .bearer

        /// Update API Key Parameters
        ///
        /// - Parameters:
        ///   - keyId: The ID of the API key to update.
        ///   - expiresAt: Optional Unix timestamp for when the key expires (null to remove expiration).
        public init(keyId: String, expiresAt: Int?) {
            self.path = "/api/api-keys/\(keyId)"
            self.body = .json(Body(expiresAt: expiresAt))
        }

    }

    // MARK: Response

    public typealias Response = APIKey

    public enum AudiobookshelfError: Error {

        case badRequest

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        403: .failure(AudiobookshelfError.forbidden),

        404: .failure(AudiobookshelfError.notFound)

    ]

}

public extension UpdateAPIKey.Parameters {

    struct Body: Encodable, Sendable {

        let expiresAt: Int?

    }

}
