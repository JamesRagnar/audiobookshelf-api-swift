//
//  PlaylistAddItem.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import Foundation
import RagnarNetworking

/// This endpoint adds an item to a playlist and returns the updated playlist.
public struct PlaylistAddItem: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationType = .bearer

        /// Playlist Add Item Parameters
        ///
        /// - Parameters:
        ///   - playlistID: The ID of the playlist.
        ///   - libraryItemID: The ID of the library item the playlist item is for.
        ///   - episodeID: The ID of the podcast episode the playlist item is for.
        public init(
            playlistID: String,
            libraryItemID: String,
            episodeID: String? = nil
        ) {
            self.path = "/api/playlists/\(playlistID)/item"
            self.body = Payload(
                libraryItemId: libraryItemID,
                episodeId: episodeID
            )
        }

    }

    // MARK: Response

    public typealias Response = Playlist

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .decode),
        /// No library item with the provided ID exists, the library item is in a different library from the playlist,
        /// the library item is already in the playlist, the library item is not a podcast and an episodeId was
        /// provided, the library item is a podcast and an episodeId was not provided, or no podcast episode with the
        /// provided ID exists in the library item.
        .code(400, .error(AudiobookshelfError.badRequest)),
        /// The playlist does not belong to the authenticated user.
        .code(403, .error(AudiobookshelfError.forbidden)),
        /// No playlist with the provided ID exists.    
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}

public extension PlaylistAddItem.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let libraryItemId: String

        let episodeId: String?

    }

}
