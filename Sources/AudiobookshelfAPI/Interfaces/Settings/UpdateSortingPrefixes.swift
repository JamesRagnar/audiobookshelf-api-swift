//
//  UpdateSortingPrefixes.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Update sorting prefixes for titles.
public struct UpdateSortingPrefixes: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String = "/api/sorting-prefixes"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        /// Update Sorting Prefixes Parameters
        ///
        /// - Parameters:
        ///   - prefixes: Array of sorting prefixes (e.g., ["the", "a", "an"]).
        public init(prefixes: [String]) {
            self.body = Payload(sortingPrefixes: prefixes)
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let rowsUpdated: Int

        public let serverSettings: ServerSettings

    }

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

public extension UpdateSortingPrefixes.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let sortingPrefixes: [String]

    }

}
