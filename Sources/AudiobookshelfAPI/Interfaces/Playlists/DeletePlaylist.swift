//
//  DeletePlaylist.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import Foundation
import RagnarNetworking

/// This endpoint deletes a playlist.
public struct DeletePlaylist: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Delete Playlist Request
        ///
        /// - Parameter playlistID: The ID of the playlist.
        public init(playlistID: String) {
            self.path = "/api/playlists/\(playlistID)"
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

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
