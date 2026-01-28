//
//  UpdateShareProgress.swift
//  AudiobookshelfAPI
//
//  Created by Ragnar Henriksen on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Update playback progress for a public share.
public struct UpdateShareProgress: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .none

        /// Update Share Progress Parameters
        ///
        /// - Parameters:
        ///   - slug: The unique share identifier.
        ///   - currentTime: Current playback position in seconds.
        public init(
            slug: String,
            currentTime: Double
        ) throws {
            self.path = "/public/share/\(slug)/progress"
            self.body = try JSONEncoder().encode(
                Body(currentTime: currentTime)
            )
        }

    }

    // MARK: Response

    public typealias Response = Data

    public enum AudiobookshelfError: Error {

        case badRequest

        case notFound

    }

    public static let responseCases: ResponseCases = [

        204: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        404: .failure(AudiobookshelfError.notFound)

    ]

}

extension UpdateShareProgress.Parameters {

    struct Body: Encodable {

        let currentTime: Double

    }

}
