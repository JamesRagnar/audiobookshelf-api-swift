//
//  BatchDeleteSessions.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Batch delete playback sessions.
public struct BatchDeleteSessions: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/sessions/batch/delete"

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public let body: RequestBody?

        public let authentication: AuthenticationType = .bearer

        /// Batch Delete Sessions Parameters
        ///
        /// - Parameters:
        ///   - sessionIds: Array of session IDs to delete.
        public init(sessionIds: [String]) {
            self.body = .json(Body(sessions: sessionIds))
        }

    }

    // MARK: Response

    public typealias Response = Data

    public enum AudiobookshelfError: Error {

        case badRequest

        case forbidden

        case internalError

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        403: .failure(AudiobookshelfError.forbidden),

        500: .failure(AudiobookshelfError.internalError)

    ]

}

public extension BatchDeleteSessions.Parameters {

    struct Body: Encodable, Sendable {

        let sessions: [String]

    }

}
