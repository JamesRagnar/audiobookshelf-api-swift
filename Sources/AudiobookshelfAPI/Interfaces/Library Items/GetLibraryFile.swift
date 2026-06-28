//
//  GetLibraryFile.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Get library file metadata.
public struct GetLibraryFile: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        public init(itemId: String, fileId: String) {
            self.path = "/api/items/\(itemId)/file/\(fileId)"
        }

    }

    // MARK: Response

    public typealias Response = Data

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(204, .noContent),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}
