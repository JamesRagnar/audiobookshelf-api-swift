//
//  RenameTag.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Rename a tag across all library items.
public struct RenameTag: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String = "/api/tags/rename"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Rename Tag Request
        ///
        /// - Parameters:
        ///   - tag: The current tag name.
        ///   - newTag: The new tag name.
        public init(
            tag: String,
            newTag: String
        ) {
            self.body = Payload(tag: tag, newTag: newTag)
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        public let tagMerged: Bool

        public let numItemsUpdated: Int

    }

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden))
        ]
    )

}

public extension RenameTag.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let tag: String

        let newTag: String

    }

}
