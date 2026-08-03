//
//  CreatePlaylistFromCollection.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import Foundation
import RagnarNetworking

/// This endpoint creates a playlist from a collection. The newly created playlist is returned.
public struct CreatePlaylistFromCollection: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Create Playlist from Collection Request
        ///
        /// - Parameter collectionID: The ID of the collection.
        public init(collectionID: String) {
            self.path = "/api/playlists/collection/\(collectionID)"
        }

    }

    // MARK: Response

    public typealias Response = Playlist

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            /// The user cannot access any books contained in the collection.
            .code(400, .error(AudiobookshelfError.badRequest)),
            /// No collection with the given ID exists.
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}
