//
//  UpdateAuthor.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Update author metadata.
public struct UpdateAuthor: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationType = .bearer

        /// Update Author Parameters
        ///
        /// - Parameters:
        ///   - authorId: The ID of the author to update.
        ///   - name: The new name of the author.
        ///   - description: The new description of the author.
        ///   - imagePath: The new image path for the author.
        ///   - asin: The new ASIN of the author.
        public init(
            authorId: String,
            name: String? = nil,
            description: String? = nil,
            imagePath: String? = nil,
            asin: String? = nil
        ) {
            self.path = "/api/authors/\(authorId)"
            self.body = Payload(
                name: name,
                description: description,
                imagePath: imagePath,
                asin: asin
            )
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        /// The updated author. When `merged` is true this is the author that was merged into.
        public let author: Author

        /// Whether renaming the author caused it to be merged into an existing author of that name.
        public let merged: Bool?

        /// Whether any field actually changed. Absent when the author was merged.
        public let updated: Bool?

    }

    public enum AudiobookshelfError: Error, Sendable {

        /// The request body contained no updatable keys.
        case badRequest

        /// You do not have the update permission.
        case forbidden

        case notFound

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}

public extension UpdateAuthor.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let name: String?

        let description: String?

        let imagePath: String?

        let asin: String?

    }

}
