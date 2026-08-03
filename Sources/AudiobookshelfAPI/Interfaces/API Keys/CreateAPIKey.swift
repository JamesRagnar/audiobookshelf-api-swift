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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String = "/api/api-keys"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Create API Key Request
        ///
        /// - Parameters:
        ///   - expiresAt: Optional Unix timestamp for when the key expires.
        public init(expiresAt: Int? = nil) {
            self.body = Payload(expiresAt: expiresAt)
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// The newly created API key.
        public let apiKey: CreatedAPIKey

    }

    /// A newly created API key, carrying the generated secret alongside the stored record.
    ///
    /// The server spreads the stored record into the same object as the secret, so both are decoded
    /// from one container.
    public struct CreatedAPIKey: Decodable, Sendable {

        /// The generated key itself.
        ///
        /// This is the only response that ever contains it; the server does not return it again.
        public let apiKey: String

        /// The stored API key record.
        public let details: APIKey

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            apiKey = try container.decode(String.self, forKey: .apiKey)
            details = try APIKey(from: decoder)
        }

        enum CodingKeys: String, CodingKey {
            case apiKey
        }

    }

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

        /// The API key could not be created.
        case internalServerError

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(500, .error(AudiobookshelfError.internalServerError))
        ]
    )

}

public extension CreateAPIKey.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let expiresAt: Int?

    }

}
