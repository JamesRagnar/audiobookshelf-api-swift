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

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        /// Batch Delete Library Items Parameters
        ///
        /// - Parameter libraryItemIds: Array of library item IDs to delete.
        public init(libraryItemIds: [String]) {
            self.body = Payload(libraryItemIds: libraryItemIds)
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public static let responseCases: ResponseMap = [

        .code(200, .noContent),
    ]

}

public extension BatchDeleteLibraryItems.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let libraryItemIds: [String]

    }

}
