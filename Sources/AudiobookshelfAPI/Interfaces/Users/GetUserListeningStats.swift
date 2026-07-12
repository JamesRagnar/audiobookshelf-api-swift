//
//  GetUserListeningStats.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Get a user's listening statistics.
public struct GetUserListeningStats: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        public init(userId: String) {
            self.path = "/api/users/\(userId)/listening-stats"
        }

    }

    // MARK: Response

    public typealias Response = UserListeningStats

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}

public extension GetUserListeningStats {

    struct UserListeningStats: Decodable, Sendable {

        public let totalTime: Int

        public let items: [String: Int]

        public let days: [String: Int]

        public let dayOfWeek: [String: Int]

        public let today: Int

        public let recentSessions: [PlaybackSession]

    }

}
