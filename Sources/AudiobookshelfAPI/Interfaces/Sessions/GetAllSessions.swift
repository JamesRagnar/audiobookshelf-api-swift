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

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        public init() {}

    }

    // MARK: Response

    public typealias Response = [PlaybackSession]

    public enum AudiobookshelfError: Error, Sendable {

        case unauthorized

    }

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .decode),
        /// Unauthorized
        .code(401, .error(AudiobookshelfError.unauthorized))
    ]

}
