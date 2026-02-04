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

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public let body: RequestBody? = nil

        public let authentication: AuthenticationType = .bearer

        public init(userId: String) {
            self.path = "/api/users/\(userId)/listening-stats"
        }

    }

    // MARK: Response

    public typealias Response = UserListeningStats

    public enum AudiobookshelfError: Error {

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        403: .failure(AudiobookshelfError.forbidden),

        404: .failure(AudiobookshelfError.notFound),

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
