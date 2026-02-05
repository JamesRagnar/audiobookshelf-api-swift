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

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil


        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        public init() {}

    }

    // MARK: Response

    public typealias Response = [PlaybackSession]

    public enum AudiobookshelfError: Error {

        case unauthorized

    }

    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self),

        /// Unauthorized
        401: .failure(AudiobookshelfError.unauthorized),

    ]

}
