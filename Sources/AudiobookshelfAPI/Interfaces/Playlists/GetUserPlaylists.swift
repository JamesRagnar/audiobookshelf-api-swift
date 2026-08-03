//
//  GetUserPlaylists.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-24.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves all playlists belonging to the authenticated user.
public struct GetUserPlaylists: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String = "/api/playlists"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Get User Playlists Request
        public init() {}

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        public let playlists: [Playlist]

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200)
    )

}
