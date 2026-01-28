//
//  GetYearStats.swift
//  AudiobookshelfAPI
//
//  Created by Ragnar Henriksen on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Get admin statistics for a specific year.
public struct GetYearStats: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data? = nil

        public let authentication: AuthenticationType = .bearer

        /// Get Year Stats Parameters
        ///
        /// - Parameters:
        ///   - year: The year to get stats for.
        public init(year: Int) {
            self.path = "/api/stats/year/\(year)"
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let numListeningSessions: Int

        public let numBooksAdded: Int

        public let numAuthorsAdded: Int

        public let totalBooksAddedSize: Int

        public let totalBooksAddedDuration: Double

        public let booksAddedWithCovers: [String]

        public let totalBooksSize: Int

        public let totalBooksDuration: Double

        public let totalListeningTime: Double

        public let numBooks: Int

        public let topAuthors: [TopItem]

        public let topNarrators: [TopItem]

        public let topGenres: [TopGenre]

    }

    public enum AudiobookshelfError: Error {

        case badRequest

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest)

    ]

}

public extension GetYearStats {

    struct TopItem: Decodable, Sendable {

        public let name: String

        public let time: Double

    }

    struct TopGenre: Decodable, Sendable {

        public let genre: String

        public let time: Double

    }

}
