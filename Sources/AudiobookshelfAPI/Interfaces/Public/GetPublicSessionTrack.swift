//
//  GetPublicSessionTrack.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-27.
//

import Foundation
import RagnarNetworking

/// Get audio track from a public playback session.
public struct GetPublicSessionTrack: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public let body: RequestBody? = nil

        public let authentication: AuthenticationType = .none

        /// Get Public Session Track Parameters
        ///
        /// - Parameters:
        ///   - sessionId: The playback session ID (UUID).
        ///   - trackIndex: The audio track index.
        public init(sessionId: String, trackIndex: Int) {
            self.path = "/public/session/\(sessionId)/track/\(trackIndex)"
        }
    }

    // MARK: Response

    public typealias Response = Data

    public enum AudiobookshelfError: Error {
        case badRequest
        case notFound
        case internalError
    }

    public static let responseCases: ResponseCases = [
        200: .success(Response.self),
        400: .failure(AudiobookshelfError.badRequest),
        404: .failure(AudiobookshelfError.notFound),
        500: .failure(AudiobookshelfError.internalError)
    ]
}
