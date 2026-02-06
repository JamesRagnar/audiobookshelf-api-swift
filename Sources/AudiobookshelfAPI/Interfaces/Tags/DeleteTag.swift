//
//  DeleteTag.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Delete a tag from all library items.
public struct DeleteTag: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Delete Tag Parameters
        ///
        /// - Parameters:
        ///   - tag: The tag name to delete.
        public init(tag: String) {
            let encodedTag = Data(tag.utf8)
                .base64EncodedString()
                .addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
            self.path = "/api/tags/\(encodedTag)"
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let numItemsUpdated: Int

    }

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(403, .error(AudiobookshelfError.forbidden)),
    ]

}
