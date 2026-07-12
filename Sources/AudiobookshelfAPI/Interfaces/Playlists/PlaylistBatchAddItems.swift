//
//  PlaylistBatchAddItems.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import Foundation
import RagnarNetworking

/// This endpoint batch adds items to a playlist and returns the updated playlist.
public struct PlaylistBatchAddItems: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public struct Item: Encodable, Sendable {

            /// The ID of the library item the playlist item is for.
            public let libraryItemId: String

            /// The ID of the podcast episode the playlist item is for.
            public let episodeId: String?

            public init(
                libraryItemId: String,
                episodeId: String?
            ) {
                self.libraryItemId = libraryItemId
                self.episodeId = episodeId
            }

        }

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = ArrayBody<Item>

        public let body: Body

        public let authentication: AuthenticationType = .bearer

        /// Playlist Batch Add Items Parameters
        ///
        /// - Parameters:
        ///   - playlistID: The ID of the playlist.
        ///   - items: The items to add to the playlist.
        public init(
            playlistID: String,
            items: [Item]
        ) {
            self.path = "/api/playlists/\(playlistID)/batch/add"
            self.body = ArrayBody(items)
        }

    }

    // MARK: Response

    public typealias Response = Playlist

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

        case notFound

        case internalError

    }

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .decode),
        /// One or more of the provided items does not have a libraryItemId.
        .code(400, .error(AudiobookshelfError.badRequest)),
        /// The playlist does not belong to the authenticated user.
        .code(403, .error(AudiobookshelfError.forbidden)),
        /// No playlist with the provided ID exists.
        .code(404, .error(AudiobookshelfError.notFound)),
        /// The provided items array was empty or did not exist.
        .code(500, .error(AudiobookshelfError.internalError))
    ]

}
