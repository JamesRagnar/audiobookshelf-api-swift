//
//  DeleteAuthorImage.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Delete an author image.
public struct DeleteAuthorImage: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Delete Author Image Parameters
        ///
        /// - Parameters:
        ///   - authorId: The ID of the author.
        public init(authorId: String) {
            self.path = "/api/authors/\(authorId)/image"
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let author: Author

    }

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden)),
    ]

}
