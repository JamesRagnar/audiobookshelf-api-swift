//
//  BatchGetLibraryItems.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Batch get library items by their IDs.
public struct BatchGetLibraryItems: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/items/batch/get"

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        /// Batch Get Library Items Parameters
        ///
        /// - Parameters:
        ///   - libraryItemIds: Array of library item IDs to retrieve.
        ///   - expanded: Whether to return expanded library items.
        public init(
            libraryItemIds: [String],
            expanded: Bool? = nil
        ) throws {
            self.body = try JSONEncoder().encode(
                Body(
                    libraryItemIds: libraryItemIds,
                    expanded: expanded
                )
            )
        }

    }

    // MARK: Response

    public typealias Response = [LibraryItem]

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

    ]

}

public extension BatchGetLibraryItems.Parameters {

    struct Body: Encodable {

        let libraryItemIds: [String]

        let expanded: Bool?

    }

}
