//
//  GetLibrarySeriesById.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// This endpoint returns a specific series from a library, optionally including progress information.
public struct GetLibrarySeriesById: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public enum Include: String {

            case progress

        }

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// Get Library Series By ID Parameters
        /// - Parameters:
        ///   - libraryId: The ID of the library.
        ///   - seriesId: The ID of the series to retrieve.
        ///   - include: What to include with the series (e.g., progress).
        public init(
            libraryId: String,
            seriesId: String,
            include: Set<Include>? = nil
        ) {
            self.path = "/api/libraries/\(libraryId)/series/\(seriesId)"

            var queryItems: [URLQueryItem] = []
            queryItems.appendIfPresent("include", include?.joined())
            self.queryItems = queryItems.isEmpty ? nil : queryItems
        }

    }

    // MARK: Response

    public typealias Response = Series

    public enum AudiobookshelfError: Error, Sendable {

        case notFound

        /// The `limit` or `page` query parameter was not a non-negative integer.
        case badRequest

        /// You do not have access to this library.
        case forbidden

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}
