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

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

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

    public enum AudiobookshelfError: Error, Sendable {
        case badRequest
        case notFound
        case internalError
    }

    public static let responseCases: ResponseMap = [
        .code(200, .decode),
        .code(204, .noContent),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(404, .error(AudiobookshelfError.notFound)),
        .code(500, .error(AudiobookshelfError.internalError))
    ]
}
