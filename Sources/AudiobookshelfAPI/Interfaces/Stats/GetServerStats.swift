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

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public typealias Body = EmptyBody

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        public init() {}

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let books: MediaStats

        public let podcasts: MediaStats

        public let total: MediaStats

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self)

    ]

}

public extension GetServerStats {

    struct MediaStats: Decodable, Sendable {

        public let totalSize: Int

        public let numItems: Int

        public let numAudioFiles: Int

    }

}
