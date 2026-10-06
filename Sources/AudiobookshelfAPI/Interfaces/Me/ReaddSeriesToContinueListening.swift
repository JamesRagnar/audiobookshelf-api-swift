//
//  ReaddSeriesToContinueListening.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Mutates the user's series-hide list rather than item progress.
/// This endpoint re-adds a series to the "Continue Listening" shelf.
public struct ReaddSeriesToContinueListening: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Readd Series To Continue Listening Request
        ///
        /// - Parameter seriesId: The ID of the series to re-add to continue listening.
        public init(seriesId: String) {
            self.path = "/api/me/series/\(seriesId)/readd-to-continue-listening"
        }

    }

    // MARK: Response

    /// Full user on changed and already-satisfied operations (2.26.0+).
    public typealias Response = User

    /// Unknown series returns 404.
    public enum AudiobookshelfError: Error, Sendable {
        case notFound
    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [.code(404, .error(AudiobookshelfError.notFound))]
    )

}
