//
//  CollectionRemoveBook.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import Foundation
import RagnarNetworking

/// Remove a book from a collection.
public struct CollectionRemoveBook: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Remove Book from Collection Parameters
        ///
        /// - Parameters:
        ///   - collectionID: The ID of the collection.
        ///   - bookID: The ID of the library item to remove.
        ///             Note: Despite the name, pass the libraryItemId here.
        public init(
            collectionID: String,
            bookID: String
        ) {
            self.path = "/api/collections/\(collectionID)/book/\(bookID)"
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
        /// A user with delete permissions is required to remove a book from a collection.
        .code(403, .error(AudiobookshelfError.forbidden)),
        /// No collection with the specified ID exists.
        .code(404, .error(AudiobookshelfError.notFound)),
    ]

}
