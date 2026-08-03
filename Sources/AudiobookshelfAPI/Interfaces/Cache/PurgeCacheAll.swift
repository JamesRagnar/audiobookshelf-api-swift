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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String = "/api/cache/purge"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Purge All Cache Request
        public init() {}

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public static let responses = ResponseContract<Response>(
        success: .exact(200)
    )

}
