//
//  GetSearchProviders.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Get all available metadata search providers.
public struct GetSearchProviders: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/api/search/providers"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        public init() {}

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let providers: Providers

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
    ]

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
