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

        public let queryItems: [String: String?]?

        public let headers: [String : String]? = nil

        public let body: RequestBody? = nil

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

            var queryItems: [String: String?] = [:]
            queryItems.setIfPresent("include", include?.joined())
            self.queryItems = queryItems.isEmpty ? nil : queryItems
        }

    }

    // MARK: Response

    public typealias Response = Series

    public enum AudiobookshelfError: Error {

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        404: .failure(AudiobookshelfError.notFound),

    ]

}
