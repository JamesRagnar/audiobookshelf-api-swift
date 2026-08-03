//
//  AddCustomMetadataProvider.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Add a new custom metadata provider.
public struct AddCustomMetadataProvider: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String = "/api/custom-metadata-providers"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        public init(
            name: String,
            url: String
        ) {
            self.body = Payload(
                name: name,
                url: url
            )
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// The newly created custom metadata provider, as the stored database row.
        public let provider: StoredCustomMetadataProvider

    }

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden))
        ]
    )

}

public extension AddCustomMetadataProvider.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let name: String

        let url: String

    }

}
