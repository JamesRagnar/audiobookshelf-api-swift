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

    public struct Parameters: RequestParameters {
        public let method: RequestMethod = .post

        public let path: String = "/api/items/batch/update"

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public typealias Body = BatchBody

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        public init(updates: [Body.UpdateItem]) {
            self.body = BatchBody(updates: updates)
        }

    }

    // MARK: Response

    public typealias Response = [LibraryItem]

    public enum AudiobookshelfError: Error {

        case forbidden

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        403: .failure(AudiobookshelfError.forbidden),

    ]

}

public extension BatchUpdateLibraryItems.Parameters {

    struct BatchBody: RequestBody {

        private let updates: [UpdateItem]

        public init(updates: [UpdateItem]) {
            self.updates = updates
        }

        public func encodeBody(using encoder: JSONEncoder) throws -> EncodedBody {
            let data = try encoder.encode(updates)
            return EncodedBody(data: data, contentType: "application/json")
        }

        public struct UpdateItem: Encodable, Sendable {

            public let id: String

            public let mediaPayload: LibraryItemMediaPayload

            public init(id: String, mediaPayload: LibraryItemMediaPayload) {
                self.id = id
                self.mediaPayload = mediaPayload
            }

        }

    }

}
