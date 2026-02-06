//
//  GetPlaylist.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves a playlist.
public struct GetPlaylist: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Get Playlist Parameters
        ///
        /// - Parameter playlistID: The ID of the playlist.
        public init(playlistID: String) {
            self.path = "/api/playlists/\(playlistID)"
        }

    }

    // MARK: Response

    public typealias Response = Playlist

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .decode),
        /// The playlist does not belong to the authenticated user.
        .code(403, .error(AudiobookshelfError.forbidden)),
        /// No playlist with the provided ID exists.
        .code(404, .error(AudiobookshelfError.notFound)),
    ]

}
