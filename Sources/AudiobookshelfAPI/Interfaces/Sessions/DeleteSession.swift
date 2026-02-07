//
//  DeleteSession.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-23.
//

import Foundation
import RagnarNetworking

/// This endpoint deletes a specific playback session.
public struct DeleteSession: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Delete Session Parameters
        ///
        /// - Parameter sessionID: The ID of the playback session to delete.
        public init(sessionID: String) {
            self.path = "/api/sessions/\(sessionID)"
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case notFound

    }

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .noContent),
        /// Session with the provided ID does not exist or user cannot access it.
        .code(404, .error(AudiobookshelfError.notFound)),
    ]

}
