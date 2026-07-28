//
//  GetAllSessions.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-23.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves all playback sessions for the authenticated user.
public struct GetAllSessions: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/api/sessions"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        public init() {}

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        /// The total number of matching sessions.
        public let total: Int

        /// The total number of pages when using this itemsPerPage limit.
        public let numPages: Int

        /// The provided page parameter.
        public let page: Int

        /// The provided itemsPerPage parameter.
        public let itemsPerPage: Int

        /// The requested sessions.
        public let sessions: [PlaybackSession]

        /// Echoed back only when the request filtered by user.
        public let userId: String?

    }

    public enum AudiobookshelfError: Error, Sendable {

        case unauthorized

        /// Returned instead of 403 when the user is not an admin.
        case notFound

    }

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .decode),
        /// Unauthorized
        .code(401, .error(AudiobookshelfError.unauthorized)),
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}
