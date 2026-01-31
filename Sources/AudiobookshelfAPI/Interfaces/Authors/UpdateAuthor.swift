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

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

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
        ) throws {
            self.path = "/api/authors/\(authorId)"
            self.body = try JSONEncoder().encode(
                Body(
                    name: name,
                    description: description,
                    imagePath: imagePath,
                    asin: asin
                )
            )
        }

    }

    // MARK: Response

    public typealias Response = Author

    public enum AudiobookshelfError: Error {

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        404: .failure(AudiobookshelfError.notFound),

    ]

}

public extension UpdateAuthor.Parameters {

    struct Body: Encodable {

        let name: String?

        let description: String?

        let imagePath: String?

        let asin: String?

    }

}
