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

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationType = .bearer

        /// Batch Get Library Items Parameters
        ///
        /// - Parameters:
        ///   - libraryItemIds: Array of library item IDs to retrieve.
        ///   - expanded: Whether to return expanded library items.
        public init(
            libraryItemIds: [String],
            expanded: Bool? = nil
        ) {
            self.body = Payload(
                libraryItemIds: libraryItemIds,
                expanded: expanded
            )
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        /// The requested library items, always expanded regardless of the `expanded` parameter.
        public let libraryItems: [LibraryItem]

    }

    public enum AudiobookshelfError: Error, Sendable {

        /// You do not have access to one of the requested library items.
        case forbidden

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(403, .error(AudiobookshelfError.forbidden))
    ]

}

public extension BatchGetLibraryItems.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let libraryItemIds: [String]

        let expanded: Bool?

    }

}
