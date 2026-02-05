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

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [String: String?]?

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        public init(
            userId: String,
            page: Int? = nil,
            itemsPerPage: Int? = nil
        ) {
            self.path = "/api/users/\(userId)/listening-sessions"
            var items: [String: String?] = [:]
            if let page = page {
                items["page"] = String(page)
            }
            if let itemsPerPage = itemsPerPage {
                items["itemsPerPage"] = String(itemsPerPage)
            }
            self.queryItems = items.isEmpty ? nil : items
        }

    }

    // MARK: Response

    public typealias Response = PaginatedResponse

    public enum AudiobookshelfError: Error {

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        403: .failure(AudiobookshelfError.forbidden),

        404: .failure(AudiobookshelfError.notFound)

    ]

}

public extension GetUserListeningSessions {

    struct PaginatedResponse: Decodable, Sendable {

        public let total: Int

        public let sessions: [PlaybackSession]

    }

}
