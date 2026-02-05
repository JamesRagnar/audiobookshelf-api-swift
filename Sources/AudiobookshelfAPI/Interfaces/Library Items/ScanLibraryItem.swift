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

    public typealias Response = LibraryItem

    public enum AudiobookshelfError: Error {

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        404: .failure(AudiobookshelfError.notFound)

    ]

}
