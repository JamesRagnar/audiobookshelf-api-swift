//
//  DeleteGenre.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Delete a genre from all library items.
public struct DeleteGenre: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil


        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Delete Genre Parameters
        ///
        /// - Parameters:
        ///   - genre: The genre name to delete.
        public init(genre: String) {
            let encodedGenre = Data(genre.utf8)
                .base64EncodedString()
                .addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
            self.path = "/api/genres/\(encodedGenre)"
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
