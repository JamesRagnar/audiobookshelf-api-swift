//
//  UpdateLibraryItemCover.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Update a library item's cover via URL or server-local image path.

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

        /// Selects a server-local image path using required wire cover (2.26.0+).
        /// On 2.37.0+ it must match a scanned file's normalized metadata.path for this item.
        /// - Parameters:
        ///   - itemId: Required library-item ID.
        ///   - coverPath: Required server-local image path, encoded as cover.

        public init(itemId: String, coverPath: String) {
            self.path = "/api/items/\(itemId)/cover"
            self.body = Payload(url: nil, cover: coverPath)
        }

        /// Legacy PATCH: url is ignored; cover is a server-local image path.
        /// Supplying only url or neither field returns 400.
        @available(*, deprecated, message: "Use init(itemId:coverPath:) or DownloadLibraryItemCoverFromURL.")
        public init(itemId: String, url: String? = nil, cover: String? = nil) {
            self.path = "/api/items/\(itemId)/cover"
            self.body = Payload(url: url, cover: cover)
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// Required wire success on 2.26.0+, including an already-selected no-op.
        public let success: Bool

        /// Required selected image path, wire cover (2.26.0+).
        public let cover: String

    }

    public enum AudiobookshelfError: Error, Sendable {

        case internalError

        case badRequest

        case forbidden

        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound)),
            .code(500, .error(AudiobookshelfError.internalError))
        ]
    )

}

public extension UpdateLibraryItemCover.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let url: String?

        let cover: String?

    }

}
