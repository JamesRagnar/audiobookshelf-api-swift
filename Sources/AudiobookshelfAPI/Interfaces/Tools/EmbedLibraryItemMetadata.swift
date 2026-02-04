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

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public let body: RequestBody?

        public let authentication: AuthenticationType = .bearer

        public init(
            itemId: String,
            backup: Bool? = nil
        ) {
            self.path = "/api/tools/item/\(itemId)/embed-metadata"
            self.body = .json(
                Body(backup: backup)
            )
        }

    }

    // MARK: Response

    public typealias Response = Data

    public enum AudiobookshelfError: Error {

        case badRequest

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        403: .failure(AudiobookshelfError.forbidden),

        404: .failure(AudiobookshelfError.notFound),

    ]

}

public extension EmbedLibraryItemMetadata.Parameters {

    struct Body: Encodable, Sendable {

        let backup: Bool?

    }

}
