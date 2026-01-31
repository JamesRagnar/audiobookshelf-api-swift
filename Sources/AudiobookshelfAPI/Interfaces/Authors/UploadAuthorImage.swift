//
//  UploadAuthorImage.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Upload an author image from a URL.
public struct UploadAuthorImage: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        /// Upload Author Image Parameters
        ///
        /// - Parameters:
        ///   - authorId: The ID of the author.
        ///   - url: The URL of the image to upload.
        public init(
            authorId: String,
            url: String
        ) throws {
            self.path = "/api/authors/\(authorId)/image"
            self.body = try JSONEncoder().encode(Body(url: url))
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let author: Author

    }

    public enum AudiobookshelfError: Error {

        case badRequest

        case forbidden

        case internalError

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        403: .failure(AudiobookshelfError.forbidden),

        500: .failure(AudiobookshelfError.internalError)

    ]

}

public extension UploadAuthorImage.Parameters {

    struct Body: Encodable {

        let url: String

    }

}
