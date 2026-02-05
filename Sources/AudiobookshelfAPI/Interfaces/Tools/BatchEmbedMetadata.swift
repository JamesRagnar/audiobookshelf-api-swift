//
//  BatchEmbedMetadata.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Batch embed metadata into audio files for multiple library items.
public struct BatchEmbedMetadata: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/tools/batch/embed-metadata"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        /// Batch Embed Metadata Parameters
        ///
        /// - Parameters:
        ///   - libraryItemIds: Array of library item IDs to embed metadata for.
        public init(libraryItemIds: [String]) {
            self.body = Payload(libraryItemIds: libraryItemIds)
        }

    }

    // MARK: Response

    public typealias Response = Data

    public enum AudiobookshelfError: Error {

        case badRequest

        case forbidden

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        403: .failure(AudiobookshelfError.forbidden)

    ]

}

public extension BatchEmbedMetadata.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let libraryItemIds: [String]

    }

}
