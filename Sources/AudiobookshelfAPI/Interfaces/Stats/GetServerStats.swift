//
//  GetServerStats.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Get server statistics.
public struct GetServerStats: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/api/stats/server"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        public init() {}

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let books: MediaStats

        public let podcasts: MediaStats

        public let total: MediaStats

    }

    public enum AudiobookshelfError: Error, Sendable {

        /// Only admins may read server statistics.
        case forbidden

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(403, .error(AudiobookshelfError.forbidden))
    ]

}

public extension GetServerStats {

    struct MediaStats: Decodable, Sendable {

        public let totalSize: Int

        public let numItems: Int

        public let numAudioFiles: Int

    }

}
