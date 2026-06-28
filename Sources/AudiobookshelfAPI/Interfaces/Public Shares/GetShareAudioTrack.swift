//
//  GetShareAudioTrack.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Get an audio track from a public share.
public struct GetShareAudioTrack: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .none

        /// Get Share Audio Track Parameters
        ///
        /// - Parameters:
        ///   - slug: The unique share identifier.
        ///   - trackIndex: The track index (0-based).
        public init(
            slug: String,
            trackIndex: Int
        ) {
            self.path = "/public/share/\(slug)/track/\(trackIndex)"
        }

    }

    // MARK: Response

    public typealias Response = Data

    public enum AudiobookshelfError: Error, Sendable {

        case notFound

        case internalError

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(204, .noContent),
        .code(404, .error(AudiobookshelfError.notFound)),
        .code(500, .error(AudiobookshelfError.internalError))
    ]

}
