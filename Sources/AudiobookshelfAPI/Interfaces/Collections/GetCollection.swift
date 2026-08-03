//
//  GetCollection.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves a collection.
public struct GetCollection: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public enum Include: String {

            case rssfeed

        }

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Get Collection Request
        ///
        /// - Parameters:
        ///   - collectionID: The ID of the collection.
        ///   - include: A comma separated list of what to include with the library item.
        public init(
            collectionID: String,
            include: Set<Include>? = nil
        ) {
            self.path = "/api/collections/\(collectionID)"

            var queryItems: [URLQueryItem] = []
            queryItems.appendIfPresent("include", include?.joined())
            self.queryItems = queryItems
        }

    }

    // MARK: Response

    public typealias Response = Collection

    public enum AudiobookshelfError: Error, Sendable {

        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            /// No collection with the specified ID exists.
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}
