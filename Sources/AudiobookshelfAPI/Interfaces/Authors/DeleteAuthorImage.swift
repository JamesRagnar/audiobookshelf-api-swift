//
//  DeleteAuthorImage.swift
//  AudiobookshelfAPI
//
//  Created by Ragnar Henriksen on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Delete an author image.
public struct DeleteAuthorImage: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data? = nil

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
