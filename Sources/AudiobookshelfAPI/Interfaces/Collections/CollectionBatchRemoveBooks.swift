//
//  CollectionBatchRemoveBooks.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import Foundation
import RagnarNetworking

/// This endpoint batch removes books from a collection and returns the collection.
public struct CollectionBatchRemoveBooks: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        /// Collection Batch Remove Books Parameters
        ///
        /// - Parameters:
        ///   - collectionID: The ID of the collection.
        ///   - bookIDs: The IDs of the book library items to remove from the collection.
        public init(
            collectionID: String,
            bookIDs: [String]
        ) {
            self.path = "/api/collections/\(collectionID)/batch/remove"
            self.body = Payload(books: bookIDs)
        }

    }

    // MARK: Response

    public typealias Response = Collection

    public enum AudiobookshelfError: Error {

        case forbidden

        case notFound

        case internalServerError

    }

    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self),

        /// A user with update permissions is required to update collections.
        403: .failure(AudiobookshelfError.forbidden),

        /// No collection with the specified ID exists.
        404: .failure(AudiobookshelfError.notFound),

        /// The provided books array must not be empty.
        500: .failure(AudiobookshelfError.internalServerError)

    ]

}

public extension CollectionBatchRemoveBooks.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let books: [String]

    }

}
