//
//  GetAuthorImage.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves an author's image.
public struct GetAuthorImage: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public typealias Format = ArtworkFormat

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .none

        /// Get Author Image Parameters
        ///
        /// - Parameters:
        ///   - authorID: The ID of the author.
        ///   - options: Scaling and cache-busting options for the requested image.
        public init(
            authorID: String,
            options: ArtworkRequestOptions = .init()
        ) {
            self.path = "/api/authors/\(authorID)/image"
            self.queryItems = options.queryItems
        }

        /// Get Author Image Parameters
        ///
        /// - Parameters:
        ///   - authorID: The ID of the author.
        ///   - width: The requested width of the image.
        ///   - height: The requested height of the image. If null the image is scaled proportionately.
        ///   - format: The requested format of the image. The default value depends on the request headers.
        ///   - raw: Whether to get the raw cover image file instead of a scaled version.
        ///   - timestamp: Cache-busting timestamp (typically the author's updatedAt value).
        public init(
            authorID: String,
            width: Int? = nil,
            height: Int? = nil,
            format: ArtworkFormat? = nil,
            raw: Bool? = nil,
            timestamp: Int? = nil
        ) {
            self.init(
                authorID: authorID,
                options: ArtworkRequestOptions(
                    width: width,
                    height: height,
                    format: format,
                    timestamp: timestamp,
                    raw: raw
                )
            )
        }

    }

    // MARK: Response

    public enum AudiobookshelfError: Error, Sendable {

        case notFound

        case internalServerError

    }

    public typealias Response = Data

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .decode),
        /// No author with provided ID exists, or the author does not have an image.
        .code(404, .error(AudiobookshelfError.notFound)),
        /// There was an error when attempting to read the image file.
        .code(500, .error(AudiobookshelfError.internalServerError))
    ]

}
