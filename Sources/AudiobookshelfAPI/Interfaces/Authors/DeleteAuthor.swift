//
//  DeleteAuthor.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Delete an author and remove them from all library items.
public struct DeleteAuthor: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Delete Author Parameters
        ///
        /// - Parameters:
        ///   - authorId: The ID of the author to delete.
        public init(authorId: String) {
            self.path = "/api/authors/\(authorId)"
        }

    }

    // MARK: Response

    public typealias Response = Data

    public enum AudiobookshelfError: Error {

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        403: .failure(AudiobookshelfError.forbidden),

        404: .failure(AudiobookshelfError.notFound)

    ]

}
