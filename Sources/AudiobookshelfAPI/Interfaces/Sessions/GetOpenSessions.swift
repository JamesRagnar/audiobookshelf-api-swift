//
//  GetOpenSessions.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves all open playback sessions.
public struct GetOpenSessions: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String = "/api/sessions/open"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        public init() {}

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// The open playback sessions, each with the owning user attached.
        public let sessions: [PlaybackSession]

        /// The open playback sessions belonging to public shares. These have no user.
        public let shareSessions: [PlaybackSession]

    }

    public enum AudiobookshelfError: Error, Sendable {

        /// Returned instead of 403 when the user is not an admin.
        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}
