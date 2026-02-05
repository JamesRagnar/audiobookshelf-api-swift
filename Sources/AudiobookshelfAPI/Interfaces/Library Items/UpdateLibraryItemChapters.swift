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

    public typealias Response = LibraryItem

    public enum AudiobookshelfError: Error {

        case badRequest

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        403: .failure(AudiobookshelfError.forbidden),

        404: .failure(AudiobookshelfError.notFound)

    ]

}

public extension UpdateLibraryItemChapters.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let chapters: [BookChapter]

    }

}
