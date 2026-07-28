//
//  RemoveLibraryMetadataFiles.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Remove all metadata files from a library.
public struct RemoveLibraryMetadataFiles: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        public init(libraryId: String) {
            self.path = "/api/libraries/\(libraryId)/remove-metadata"
        }

    }

    // MARK: Response

    public typealias Response = RemoveMetadataFilesResponse

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

        /// The `limit` or `page` query parameter was not a non-negative integer.
        case badRequest

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}

public extension RemoveLibraryMetadataFiles {

    struct RemoveMetadataFilesResponse: Decodable, Sendable {

        public let found: Int

        public let removed: Int

    }

}
