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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

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

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}

public extension GetUserListeningStats {

    struct UserListeningStats: Decodable, Sendable, InterfaceResponse {

        public let totalTime: Double

        public let items: [String: Double]

        public let days: [String: Double]

        public let dayOfWeek: [String: Double]

        public let today: Double

        public let recentSessions: [PlaybackSession]

    }

}
