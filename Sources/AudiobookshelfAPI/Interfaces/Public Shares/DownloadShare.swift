//
//  DownloadShare.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Download media from a public share.
public struct DownloadShare: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .none

        /// Download Share Parameters
        ///
        /// - Parameters:
        ///   - slug: The unique share identifier.
        public init(slug: String) {
            self.path = "/public/share/\(slug)/download"
        }

    }

    // MARK: Response

    public typealias Response = Data

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

        case internalError

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound)),
        .code(500, .error(AudiobookshelfError.internalError))
    ]

}
