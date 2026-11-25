//
//  CollectionRemoveBook.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import Foundation
import RagnarNetworking

/// Remove a book from a collection.
///
/// On server 2.38.0+, results are filtered for the requesting user's tag and explicit-content permissions.
/// A successful mutation can return JSON `null` when a nonempty collection has no visible books.
/// This decodes to nil and does not mean the mutation failed. A partially visible collection contains
/// only visible books. A genuinely empty collection returns an object with an empty books array.
public struct CollectionRemoveBook: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Remove Book from Collection Request
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

    public typealias Response = Collection?

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            /// On 2.38.0+, removing a book requires update permission; older servers require delete permission.
            /// Whole-collection deletion still requires delete permission.
            .code(403, .error(AudiobookshelfError.forbidden)),
            /// No collection with the specified ID exists.
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}
