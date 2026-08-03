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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Upload Author Image Request
        ///
        /// - Parameters:
        ///   - authorId: The ID of the author.
        ///   - url: The URL of the image to upload.
        public init(
            authorId: String,
            url: String
        ) {
            self.path = "/api/authors/\(authorId)/image"
            self.body = Payload(url: url)
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        public let author: Author

    }

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

        case internalError

        /// No author exists with the given ID.
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

public extension UploadAuthorImage.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let url: String

    }

}
