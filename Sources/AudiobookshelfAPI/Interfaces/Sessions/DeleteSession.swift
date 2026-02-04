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

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public typealias Body = EmptyBody

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

    public typealias Response = String

    public enum AudiobookshelfError: Error {

        case notFound

    }

    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self),

        /// Session with the provided ID does not exist or user cannot access it.
        404: .failure(AudiobookshelfError.notFound),

    ]

}
