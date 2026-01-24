//
//  DeleteLibraryItem.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Delete a library item.
public struct DeleteLibraryItem: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data? = nil

        public let authentication: AuthenticationType = .bearer

        /// Delete Library Item Parameters
        ///
        /// - Parameter itemId: The ID of the library item to delete.
        public init(itemId: String) {
            self.path = "/api/items/\(itemId)"
        }

    }

    // MARK: Response

    public typealias Response = Data

    public enum AudiobookshelfError: Error {

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        404: .failure(AudiobookshelfError.notFound),

    ]

}
