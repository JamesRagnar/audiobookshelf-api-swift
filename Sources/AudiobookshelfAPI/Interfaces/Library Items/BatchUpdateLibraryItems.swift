//
//  BatchUpdateLibraryItems.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Batch update library items.
public struct BatchUpdateLibraryItems: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {
        public let method: RequestMethod = .post

        public let path: String = "/api/items/batch/update"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = BatchBody

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        public init(updates: [Body.UpdateItem]) {
            self.body = BatchBody(updates: updates)
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        public let success: Bool

        public let updates: Int

    }

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(404, .error(AudiobookshelfError.notFound)),
            .code(403, .error(AudiobookshelfError.forbidden))
        ]
    )

}

public extension BatchUpdateLibraryItems.Request {

    struct BatchBody: RequestBody {

        private let updates: [UpdateItem]

        public init(updates: [UpdateItem]) {
            self.updates = updates
        }

        public func encodeBody(using encoder: RequestEncoder) throws -> EncodedBody {
            let data = try encoder.encode(updates)
            return EncodedBody(data: data, contentType: "application/json")
        }

        public struct UpdateItem: Encodable, Sendable {

            public let id: String

            public let mediaPayload: UpdateLibraryItemMedia.Request.LibraryItemMediaPayload

            public init(id: String, mediaPayload: UpdateLibraryItemMedia.Request.LibraryItemMediaPayload) {
                self.id = id
                self.mediaPayload = mediaPayload
            }

        }

    }

}
