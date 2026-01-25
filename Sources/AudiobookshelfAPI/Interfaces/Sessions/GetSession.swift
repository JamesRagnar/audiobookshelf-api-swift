//
//  GetSession.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Retrieves a specific playback session by ID.
public struct GetSession: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data? = nil

        public let authentication: AuthenticationType = .bearer

        public init(sessionId: String) {
            self.path = "/api/sessions/\(sessionId)"
        }

    }

    // MARK: Response

    public typealias Response = PlaybackSession

    public enum AudiobookshelfError: Error {

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        404: .failure(AudiobookshelfError.notFound),

    ]

}
