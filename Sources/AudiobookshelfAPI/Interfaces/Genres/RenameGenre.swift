//
//  RenameGenre.swift
//  AudiobookshelfAPI
//
//  Created by Ragnar Henriksen on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Rename a genre across all library items.
public struct RenameGenre: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/genres/rename"

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        /// Rename Genre Parameters
        ///
        /// - Parameters:
        ///   - genre: The current genre name.
        ///   - newGenre: The new genre name.
        public init(
            genre: String,
            newGenre: String
        ) throws {
            self.body = try JSONEncoder().encode(
                Body(genre: genre, newGenre: newGenre)
            )
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let genreMerged: Bool

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

extension RenameGenre.Parameters {

    struct Body: Encodable {

        let genre: String

        let newGenre: String

    }

}
