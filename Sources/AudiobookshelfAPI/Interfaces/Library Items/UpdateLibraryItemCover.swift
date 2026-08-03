//
//  UpdateLibraryItemCover.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Update a library item's cover via URL or base64 data.
public struct UpdateLibraryItemCover: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        public init(itemId: String, url: String? = nil, cover: String? = nil) {
            self.path = "/api/items/\(itemId)/cover"
            self.body = Payload(url: url, cover: cover)
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        public let success: Bool

        public let cover: String

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
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}

public extension UpdateLibraryItemCover.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let url: String?

        let cover: String?

    }

}
