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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String = "/api/tools/batch/embed-metadata"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Batch Embed Metadata Request
        ///
        /// - Parameters:
        ///   - libraryItemIds: Array of library item IDs to embed metadata for.
        public init(libraryItemIds: [String]) {
            self.body = Payload(libraryItemIds: libraryItemIds)
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden))
        ]
    )

}

public extension BatchEmbedMetadata.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let libraryItemIds: [String]

    }

}
