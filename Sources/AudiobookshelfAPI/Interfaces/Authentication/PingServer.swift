//
//  PingServer.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-20.
//

import Foundation
import RagnarNetworking

///
public struct PingServer: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/ping"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .none

        /// Ping Server Parameters
        public init() {}

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        /// Will always be true.
        public let success: Bool

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode)
    ]

}
