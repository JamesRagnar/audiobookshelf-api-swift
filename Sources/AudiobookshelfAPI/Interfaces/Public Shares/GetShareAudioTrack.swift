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

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data? = nil

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

    public enum AudiobookshelfError: Error {

        case notFound

        case internalError

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        204: .success(Response.self),

        404: .failure(AudiobookshelfError.notFound),

        500: .failure(AudiobookshelfError.internalError)

    ]

}
