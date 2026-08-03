//
//  GetCustomMetadataProviders.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Get all custom metadata providers.
public struct GetCustomMetadataProviders: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String = "/api/custom-metadata-providers"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        public init() {}

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// The configured custom metadata providers, as stored database rows.
        ///
        /// The server returns the records directly rather than the filtered client shape, so these
        /// carry `url` and `authHeaderValue` and have no `slug`.
        public let providers: [StoredCustomMetadataProvider]

    }

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(403, .error(AudiobookshelfError.forbidden))
        ]
    )

}
