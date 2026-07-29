//
//  GetOnlineUsers.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Get online users.
public struct GetOnlineUsers: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/api/users/online"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        public init() {}

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        /// The users with at least one open socket connection.
        public let usersOnline: [PublicUser]

        /// Every open playback session on the server.
        public let openSessions: [PlaybackSession]

    }

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(403, .error(AudiobookshelfError.forbidden))
    ]

}
