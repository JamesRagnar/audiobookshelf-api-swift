//
//  UpdateLibraryItemChapters.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Update chapters for a library item.
public struct UpdateLibraryItemChapters: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        public init(itemId: String, chapters: [BookChapter]) {
            self.path = "/api/items/\(itemId)/chapters"
            self.body = Payload(chapters: chapters)
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let success: Bool

        public let updated: Bool

    }

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}

public extension UpdateLibraryItemChapters.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let chapters: [BookChapter]

    }

}
