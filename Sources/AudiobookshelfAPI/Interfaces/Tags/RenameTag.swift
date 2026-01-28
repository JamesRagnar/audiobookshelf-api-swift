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

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/tags/rename"

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        /// Rename Tag Parameters
        ///
        /// - Parameters:
        ///   - tag: The current tag name.
        ///   - newTag: The new tag name.
        public init(
            tag: String,
            newTag: String
        ) throws {
            self.body = try JSONEncoder().encode(
                Body(tag: tag, newTag: newTag)
            )
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let tagMerged: Bool

        public let numItemsUpdated: Int

    }

    public enum AudiobookshelfError: Error {

        case badRequest

        case forbidden

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        403: .failure(AudiobookshelfError.forbidden)

    ]

}

extension RenameTag.Parameters {

    struct Body: Encodable {

        let tag: String

        let newTag: String

    }

}
