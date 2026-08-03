//
//  UpdatePlaylist.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import Foundation
import RagnarNetworking

/// This endpoint updates a playlist and returns it.
public struct UpdatePlaylist: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Update Playlist Request
        ///
        /// - Parameters:
        ///   - playlistID: The ID of the playlist.
        ///   - name: The playlist's name.
        ///   - description: The playlist's description.
        ///   - coverPath: The path of the playlist's cover.
        ///   - items: Optional array of playlist items for reordering.
        ///            Must contain ALL existing items in the new order.
        public init(
            playlistID: String,
            name: String,
            description: String? = nil,
            coverPath: String? = nil,
            items: [PlaylistItem]? = nil
        ) {
            self.path = "/api/playlists/\(playlistID)"
            self.body = Payload(
                name: name,
                description: description,
                coverPath: coverPath,
                items: items?.map {
                    Item(libraryItemId: $0.libraryItemId, episodeId: $0.episodeId)
                }
            )
        }

    }

    // MARK: Response

    public typealias Response = Playlist

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            /// The playlist does not belong to the authenticated user.
            .code(403, .error(AudiobookshelfError.forbidden)),
            /// No playlist with the provided ID exists.
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}

public extension UpdatePlaylist.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let name: String

        let description: String?

        let coverPath: String?

        /// Optional array of playlist items for reordering existing items.
        /// Must contain all existing items in the desired order.
        let items: [Item]?

    }

    /// Request-specific model for playlist items in update body.
    /// Only includes the minimal fields required by the server.
    struct Item: Encodable, Sendable {

        /// The ID of the library item.
        let libraryItemId: String

        /// The ID of the podcast episode (if applicable).
        let episodeId: String?

    }

}
