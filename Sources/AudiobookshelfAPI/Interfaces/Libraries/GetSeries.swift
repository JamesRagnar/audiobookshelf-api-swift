//
//  GetSeries.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2025-01-27.
//

import Foundation
import RagnarNetworking

/// Get a single series with its books.
public struct GetSeries: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [String : String]?

        public let headers: [String : String]? = nil

        public let body: Data? = nil

        public let authentication: AuthenticationType = .bearer

        /// Get Series Parameters
        ///
        /// - Parameters:
        ///   - libraryId: The ID of the library.
        ///   - seriesId: The ID of the series.
        ///   - include: Optional includes (progress, rssfeed).
        public init(
            libraryId: String,
            seriesId: String,
            include: [String]? = nil
        ) {
            self.path = "/api/libraries/\(libraryId)/series/\(seriesId)"

            if let include = include, !include.isEmpty {
                self.queryItems = ["include": include.joined(separator: ",")]
            } else {
                self.queryItems = nil
            }
        }
    }

    // MARK: Response

    public typealias Response = Series

    public enum AudiobookshelfError: Error {
        case notFound
    }

    public static let responseCases: ResponseCases = [
        200: .success(Response.self),
        404: .failure(AudiobookshelfError.notFound)
    ]
}
