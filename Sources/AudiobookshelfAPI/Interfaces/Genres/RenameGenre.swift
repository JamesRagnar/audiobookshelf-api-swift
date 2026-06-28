//
//  RenameGenre.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Rename a genre across all library items.
public struct RenameGenre: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/genres/rename"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationType = .bearer

        /// Rename Genre Parameters
        ///
        /// - Parameters:
        ///   - genre: The current genre name.
        ///   - newGenre: The new genre name.
        public init(
            genre: String,
            newGenre: String
        ) {
            self.body = Payload(genre: genre, newGenre: newGenre)
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let genreMerged: Bool

        public let numItemsUpdated: Int

    }

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden))
    ]

}

public extension RenameGenre.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let genre: String

        let newGenre: String

    }

}
