//
//  DeleteCollection.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import Foundation
import RagnarNetworking

/// This endpoint deletes a collection from the database.
public struct DeleteCollection: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// Delete Collection Parameters
        ///
        /// - Parameter collectionID: The ID of the collection.
        public init(collectionID: String) {
            self.path = "/api/collections/\(collectionID)"
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .noContent),
        /// A user with delete permissions is required to delete a collection.
        .code(403, .error(AudiobookshelfError.forbidden)),
        /// No collection with the specified ID exists.
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}
