//
//  BatchScanLibraryItems.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Batch scan library items for changes.
public struct BatchScanLibraryItems: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/items/batch/scan"

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        public init(libraryItemIds: [String]) throws {
            self.body = try JSONEncoder().encode(
                Body(libraryItemIds: libraryItemIds)
            )
        }

    }

    // MARK: Response

    public typealias Response = Data

    public enum AudiobookshelfError: Error {

        case forbidden

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        403: .failure(AudiobookshelfError.forbidden),

    ]

}

extension BatchScanLibraryItems.Parameters {

    struct Body: Encodable {

        let libraryItemIds: [String]

    }

}
