//
//  GetUserListeningSessions.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Get a user's listening sessions with pagination.
public struct GetUserListeningSessions: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        public init(
            userId: String,
            page: Int? = nil,
            itemsPerPage: Int? = nil
        ) {
            self.path = "/api/users/\(userId)/listening-sessions"
            var items: [URLQueryItem] = []
            items.appendIfPresent("page", page?.description)
            items.appendIfPresent("itemsPerPage", itemsPerPage?.description)
            self.queryItems = items.isEmpty ? nil : items
        }

    }

    // MARK: Response

    public typealias Response = PaginatedResponse

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

public extension GetUserListeningSessions {

    struct PaginatedResponse: Decodable, Sendable, InterfaceResponse {

        public let total: Int

        public let sessions: [PlaybackSession]

    }

}
