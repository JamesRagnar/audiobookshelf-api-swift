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

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/custom-metadata-providers"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationType = .bearer

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

    public struct Response: Decodable, Sendable {

        /// The newly created custom metadata provider.
        public let provider: CreatedProvider

        /// The raw database row for a provider.
        ///
        /// This endpoint serializes the stored record directly rather than the client-facing shape,
        /// so it exposes `url` and `authHeaderValue` but carries no `slug`. Use
        /// `GetCustomMetadataProviders` for the ``CustomMetadataProvider`` shape.
        public struct CreatedProvider: Decodable, Sendable {

            /// The ID of the provider.
            public let id: String

            /// The name of the provider.
            public let name: String

            /// The media type the provider applies to.
            public let mediaType: String

            /// The provider's endpoint URL.
            public let url: String

            /// The value sent in the Authorization header, when one was configured.
            public let authHeaderValue: String?

        }

    }

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden))
    ]

}

public extension AddCustomMetadataProvider.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let name: String

        let url: String

    }

}
