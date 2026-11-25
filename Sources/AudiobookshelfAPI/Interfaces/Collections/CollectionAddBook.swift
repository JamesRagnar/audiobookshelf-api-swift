//
//  CollectionAddBook.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import Foundation
import RagnarNetworking

/// This endpoint adds a book to a collection and returns the collection.
///
/// On server 2.38.0+, results are filtered for the requesting user's tag and explicit-content permissions.
/// A successful mutation can return JSON `null` when a nonempty collection has no visible books.
/// This decodes to nil and does not mean the mutation failed. A partially visible collection contains
/// only visible books. A genuinely empty collection returns an object with an empty books array.
public struct CollectionAddBook: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Collection Add Book Request
        ///
        /// - Parameters:
        ///   - collectionID: The ID of the collection.
        ///   - bookID: The ID of the book library item to add to the collection.
        public init(
            collectionID: String,
            bookID: String
        ) {
            self.path = "/api/collections/\(collectionID)/book"

            self.body = Payload(id: bookID)
        }

    }

    // MARK: Response

    public typealias Response = Collection?

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

        case internalError

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            /// A user with update permissions is required to update collections.
            .code(403, .error(AudiobookshelfError.forbidden)),
            /// No collection with the specified ID exists.
            .code(404, .error(AudiobookshelfError.notFound)),
            /// The provided library item ID was not found, belongs to a different library,
            /// or is already in the collection.
            .code(500, .error(AudiobookshelfError.internalError))
        ]
    )

}

public extension CollectionAddBook.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let id: String

    }

}
