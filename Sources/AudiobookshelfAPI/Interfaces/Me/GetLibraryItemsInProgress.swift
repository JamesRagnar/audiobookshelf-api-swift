//
//  GetLibraryItemsInProgress.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2025-02-24.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves library items that are in progress (started, not finished).
public struct GetLibraryItemsInProgress: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/api/me/items-in-progress"

        public let queryItems: [String: String?]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// GetLibraryItemsInProgress Parameters
        ///
        /// - Parameter limit: A limit for how many library items to return.
        public init(
            limit: Int? = nil
        ) {
            var queryItems = [String: String?]()
            queryItems.setIfPresent("limit", limit?.description)
            self.queryItems = queryItems
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        /// The in progress library items.
        public let libraryItems: [LibraryItem]

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode)
    ]

}
