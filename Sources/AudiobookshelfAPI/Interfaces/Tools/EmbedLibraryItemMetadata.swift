//
//  EmbedLibraryItemMetadata.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Embed metadata in audio files for a library item.
public struct EmbedLibraryItemMetadata: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationType = .bearer

        public init(
            itemId: String,
            backup: Bool? = nil
        ) {
            self.path = "/api/tools/item/\(itemId)/embed-metadata"
            self.body = Payload(backup: backup)
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseMap = [

        .code(200, .noContent),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}

public extension EmbedLibraryItemMetadata.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let backup: Bool?

    }

}
