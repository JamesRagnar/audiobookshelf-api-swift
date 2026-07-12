//
//  UpdateShareProgress.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Update playback progress for a public share.
public struct UpdateShareProgress: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationType = .none

        /// Update Share Progress Parameters
        ///
        /// - Parameters:
        ///   - slug: The unique share identifier.
        ///   - currentTime: Current playback position in seconds.
        public init(
            slug: String,
            currentTime: Double
        ) {
            self.path = "/public/share/\(slug)/progress"
            self.body = Payload(currentTime: currentTime)
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case notFound

    }

    public static let responseCases: ResponseMap = [

        .code(204, .noContent),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}

public extension UpdateShareProgress.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let currentTime: Double

    }

}
