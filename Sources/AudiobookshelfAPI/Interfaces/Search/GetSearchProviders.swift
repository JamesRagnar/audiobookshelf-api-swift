//
//  GetSearchProviders.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Get all available metadata search providers.
/// - Note: This endpoint was added in server `2.31.0`.
public struct GetSearchProviders: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String = "/api/search/providers"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        public init() {}

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        public let providers: Providers

    }

    public enum AudiobookshelfError: Error, Sendable {

        /// Endpoint is unavailable on server versions before `2.31.0`.
        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}

public extension GetSearchProviders {

    struct Providers: Decodable, Sendable {

        public let books: [Provider]

        public let booksCovers: [Provider]

        public let podcasts: [Provider]

    }

    struct Provider: Decodable, Sendable {

        public let value: String

        public let text: String

    }

}
