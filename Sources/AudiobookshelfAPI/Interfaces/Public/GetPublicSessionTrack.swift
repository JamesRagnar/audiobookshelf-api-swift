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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = nil

        /// Get Public Session Track Request
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

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        additionalSuccesses: [.exact(204)],
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(404, .error(AudiobookshelfError.notFound)),
            .code(500, .error(AudiobookshelfError.internalError))
        ]
    )
}
