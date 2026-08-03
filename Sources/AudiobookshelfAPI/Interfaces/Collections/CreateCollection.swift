//
//  CreateCollection.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import Foundation
import RagnarNetworking

/// This endpoint creates a collection and returns it.
public struct CreateCollection: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String = "/api/collections"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Create Collection Request
        /// 
        /// - Parameters:
        ///   - libraryID: The ID of the library the collection belongs to.
        ///   - name: The name of the collection.
        ///   - description: The collection's description.
        ///   - books: The IDs of book library items that are in the collection.
        public init(
            libraryID: String,
            name: String,
            description: String? = nil,
            books: [String]? = nil
        ) {
            let body = Payload(
                libraryID: libraryID,
                name: name,
                description: description,
                books: books
            )

            self.body = body
        }

    }

    // MARK: Response

    public typealias Response = Collection

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case internalError

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            /// A user with update permissions is required to create collections.
            .code(403, .error(AudiobookshelfError.forbidden)),
            /// libraryId and name are required parameters.
            .code(500, .error(AudiobookshelfError.internalError))
        ]
    )

}

public extension CreateCollection.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let libraryID: String

        let name: String

        let description: String?

        let books: [String]?

    }

}
