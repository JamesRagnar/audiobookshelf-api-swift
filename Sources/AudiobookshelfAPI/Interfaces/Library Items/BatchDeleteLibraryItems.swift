//
//  BatchDeleteLibraryItems.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Batch delete library items by their IDs.
public struct BatchDeleteLibraryItems: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/items/batch/delete"

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        /// Batch Delete Library Items Parameters
        ///
        /// - Parameter libraryItemIds: Array of library item IDs to delete.
        public init(libraryItemIds: [String]) throws {
            self.body = try JSONEncoder().encode(
                Body(libraryItemIds: libraryItemIds)
            )
        }

    }

    // MARK: Response

    public typealias Response = Data

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

    ]

}

public extension BatchDeleteLibraryItems.Parameters {

    struct Body: Encodable {

        let libraryItemIds: [String]

    }

}
