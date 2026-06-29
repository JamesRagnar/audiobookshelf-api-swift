//
//  CollectionBatchAddBooks.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import Foundation
import RagnarNetworking

/// This endpoint batch adds books to a collection and returns the collection.
public struct CollectionBatchAddBooks: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationType = .bearer

        /// Collection Batch Add Books
        ///
        /// - Parameters:
        ///   - collectionID: The ID of the collection.
        ///   - bookIDs: The IDs of the book library items to add to the collection.
        public init(
            collectionID: String,
            bookIDs: [String]
        ) {
            self.path = "/api/collections/\(collectionID)/batch/add"
            self.body = Payload(books: bookIDs)
        }

    }

    // MARK: Response

    public typealias Response = Collection

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

        case internalError

    }

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .decode),
        /// A user with update permissions is required to update collections.
        .code(403, .error(AudiobookshelfError.forbidden)),
        /// No collection with the specified ID exists.
        .code(404, .error(AudiobookshelfError.notFound)),
        /// The provided books array must not be empty.
        .code(500, .error(AudiobookshelfError.internalError))
    ]

}

public extension CollectionBatchAddBooks.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let books: [String]

    }

}
