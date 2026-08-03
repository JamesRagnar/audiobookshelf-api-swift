//
//  GetAllCollections.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-24.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves all collections.
public struct GetAllCollections: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String = "/api/collections"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Get All Collections Request
        public init() {}

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        public let collections: [Collection]

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200)
    )

}
