//
//  DeleteTag.swift
//  AudiobookshelfAPI
//
//  Created by Ragnar Henriksen on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Delete a tag from all library items.
public struct DeleteTag: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data? = nil

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

    public enum AudiobookshelfError: Error {

        case forbidden

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        403: .failure(AudiobookshelfError.forbidden)

    ]

}
