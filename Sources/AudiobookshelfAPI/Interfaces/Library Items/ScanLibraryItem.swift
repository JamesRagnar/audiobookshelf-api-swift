//
//  ScanLibraryItem.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Scan or rescan a library item.
public struct ScanLibraryItem: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Scan Library Item Parameters
        ///
        /// - Parameter itemId: The ID of the library item to scan.
        public init(itemId: String) {
            self.path = "/api/items/\(itemId)/scan"
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let result: String

    }

    public enum AudiobookshelfError: Error, Sendable {

        case notFound

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}
