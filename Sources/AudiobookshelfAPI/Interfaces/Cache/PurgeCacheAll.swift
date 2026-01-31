//
//  PurgeCacheAll.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Purge all server cache (broader than items-only cache purge).
public struct PurgeCacheAll: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/cache/purge"

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data? = nil

        public let authentication: AuthenticationType = .bearer

        /// Purge All Cache Parameters
        public init() {}

    }

    // MARK: Response

    public typealias Response = String

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

    ]

}
