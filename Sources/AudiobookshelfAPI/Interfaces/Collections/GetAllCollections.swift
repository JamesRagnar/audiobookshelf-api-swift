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

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/api/collections"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// Get All Collections Parameters
        public init() {}

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let collections: [Collection]

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode)
    ]

}
