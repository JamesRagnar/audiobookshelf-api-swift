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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String = "/api/items/batch/get"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Batch Get Library Items Request
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

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// The requested library items, always expanded regardless of the `expanded` parameter.
        public let libraryItems: [LibraryItem]

    }

    public enum AudiobookshelfError: Error, Sendable {

        /// You do not have access to one of the requested library items, or `libraryItemIDs` was
        /// empty. The server uses this code for both.
        case forbidden

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(403, .error(AudiobookshelfError.forbidden))
        ]
    )

}

public extension BatchGetLibraryItems.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let libraryItemIds: [String]

        let expanded: Bool?

    }

}
