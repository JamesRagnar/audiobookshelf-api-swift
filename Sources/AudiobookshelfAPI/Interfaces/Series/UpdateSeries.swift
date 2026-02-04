//
//  UpdateSeries.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Update series metadata.
public struct UpdateSeries: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public let body: RequestBody?

        public let authentication: AuthenticationType = .bearer

        /// Update Series Parameters
        ///
        /// - Parameters:
        ///   - seriesId: The ID of the series to update.
        ///   - name: The new name of the series.
        ///   - description: The new description of the series.
        public init(
            seriesId: String,
            name: String? = nil,
            description: String? = nil
        ) {
            self.path = "/api/series/\(seriesId)"
            self.body = .json(
                Body(
                    name: name,
                    description: description
                )
            )
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

public extension UpdateSeries.Parameters {

    struct Body: Encodable, Sendable {

        let name: String?

        let description: String?

    }

}
