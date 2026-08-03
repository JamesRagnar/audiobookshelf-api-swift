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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String = "/ping"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = nil

        /// Ping Server Request
        public init() {}

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// Will always be true.
        public let success: Bool

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200)
    )

}
