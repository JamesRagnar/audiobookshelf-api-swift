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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = nil

        /// Update Share Progress Request
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

    public static let responses = ResponseContract<Response>(
        success: .exact(204),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}

public extension UpdateShareProgress.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let currentTime: Double

    }

}
