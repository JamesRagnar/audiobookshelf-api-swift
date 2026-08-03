//
//  UpdateAPIKey.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Update an API key's active state or owning user.
public struct UpdateAPIKey: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Update API Key Request
        ///
        /// Only `isActive` and `userId` can be changed. The key's name and expiry are baked into the
        /// JWT at creation and the server ignores any attempt to update them.
        ///
        /// - Parameters:
        ///   - keyId: The ID of the API key to update.
        ///   - isActive: Whether the key can be used to authenticate. Omit to leave unchanged.
        ///   - userId: The ID of the user the key acts as. Omit to leave unchanged.
        public init(
            keyId: String,
            isActive: Bool? = nil,
            userId: String? = nil
        ) {
            self.path = "/api/api-keys/\(keyId)"
            self.body = Payload(isActive: isActive, userId: userId)
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// The updated API key. The generated key itself is never returned again after creation.
        public let apiKey: APIKey

    }

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}

public extension UpdateAPIKey.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let isActive: Bool?

        let userId: String?

    }

}
