//
//  GetAllLibraries.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves all libraries accessible to the user.
public struct GetAllLibraries: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String = "/api/libraries"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Get All Libraries Request
        public init() {}

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        public let libraries: [Library]

    }

    public static let responses = ResponseContract<Response>(
        /// The requested libraries.
        success: .exact(200)
    )

}
