//
//  UpdateCollection.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import Foundation
import RagnarNetworking

/// This endpoint updates a collection and returns it.
public struct UpdateCollection: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        /// Update Collection Parameters
        ///
        /// - Parameters:
        ///   - collectionID: The ID of the collection.
        ///   - libraryID: The ID of the library the collection belongs to.
        ///   - name: The name of the collection.
        ///   - description: The collection's description.
        ///   - books: The IDs of book library items that are in the collection.
        public init(
            collectionID: String,
            libraryID: String,
            name: String,
            description: String? = nil,
            books: [String]? = nil
        ) {
            self.path = "/api/collections/\(collectionID)"

            self.body = Payload(
                libraryID: libraryID,
                name: name,
                description: description,
                books: books
            )
        }

    }

    // MARK: Response

    public typealias Response = Collection

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .decode),
        /// A user with update permissions is required to update collections.
        .code(403, .error(AudiobookshelfError.forbidden)),
        /// No collection with the specified ID exists.
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}

public extension UpdateCollection.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let libraryID: String

        let name: String

        let description: String?

        let books: [String]?

    }

}
