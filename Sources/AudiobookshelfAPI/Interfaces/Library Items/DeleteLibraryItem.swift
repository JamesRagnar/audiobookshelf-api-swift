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

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Delete Library Item Parameters
        ///
        /// - Parameter itemId: The ID of the library item to delete.
        public init(itemId: String) {
            self.path = "/api/items/\(itemId)"
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case notFound

    }

    public static let responseCases: ResponseMap = [

        .code(200, .noContent),
        .code(404, .error(AudiobookshelfError.notFound)),
    ]

}
