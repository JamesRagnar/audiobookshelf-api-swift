//
//  GetLibraryFilterData.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-22.
//

import Foundation
import RagnarNetworking

/// This endpoint returns a library's filter data that can be used for displaying a filter list.
public struct GetLibraryFilterData: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// Get Library Filter Data Parameters
        ///
        /// - Parameter libraryID: The ID of the library.
        public init(libraryID: String) {
            self.path = "/api/libraries/\(libraryID)/filterdata"
        }

    }

    // MARK: Response

    public typealias Response = LibraryFilterData

    public enum AudiobookshelfError: Error, Sendable {

        /// The `limit` or `page` query parameter was not a non-negative integer.
        case badRequest

        /// You do not have access to this library.
        case forbidden

        case notFound

    }

    public static let responseCases: ResponseMap = [

        /// Success
        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden)),
        /// The user cannot access the library, or no library with the provided ID exists.
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}
