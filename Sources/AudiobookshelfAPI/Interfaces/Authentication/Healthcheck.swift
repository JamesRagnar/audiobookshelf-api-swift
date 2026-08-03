//
//  Healthcheck.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-21.
//

import Foundation
import RagnarNetworking

/// This endpoint is a simple check to see if the server is operating and can respond.
public struct Healthcheck: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String = "/healthcheck"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = nil

        /// Healthcheck Request
        public init() {}

    }

    // MARK: Response

    public typealias Response = String

    public static let responses = ResponseContract<Response>(
        success: .exact(200)
    )

}
