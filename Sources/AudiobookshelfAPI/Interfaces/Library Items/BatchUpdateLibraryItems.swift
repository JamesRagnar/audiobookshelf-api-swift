//
//  BatchUpdateLibraryItems.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Batch update library items.
public struct BatchUpdateLibraryItems: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/items/batch/update"

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        public init(libraryItemIds: [String], mediaPayload: [String: Any]) throws {
            let bodyDict: [String: Any] = [
                "libraryItemIds": libraryItemIds,
                "mediaPayload": mediaPayload
            ]
            self.body = try JSONSerialization.data(withJSONObject: bodyDict)
        }

    }

    // MARK: Response

    public typealias Response = [LibraryItem]

    public enum AudiobookshelfError: Error {

        case forbidden

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        403: .failure(AudiobookshelfError.forbidden),

    ]

}
