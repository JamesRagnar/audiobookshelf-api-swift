//
//  GetShareCover.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Get the cover image from a public share.
public struct GetShareCover: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = nil

        /// Get Share Cover Request
        ///
        /// - Parameters:
        ///   - slug: The unique share identifier.
        public init(slug: String) {
            self.path = "/public/share/\(slug)/cover"
        }

    }

    // MARK: Response

    public typealias Response = Data

    public enum AudiobookshelfError: Error, Sendable {

        case notFound

        case internalError

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        additionalSuccesses: [.exact(204)],
        failures: [
            .code(404, .error(AudiobookshelfError.notFound)),
            .code(500, .error(AudiobookshelfError.internalError))
        ]
    )

}
