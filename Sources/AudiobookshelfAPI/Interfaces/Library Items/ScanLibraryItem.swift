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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Scan Library Item Request
        ///
        /// - Parameter itemId: The ID of the library item to scan.
        public init(itemId: String) {
            self.path = "/api/items/\(itemId)/scan"
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        public let result: String

    }

    public enum AudiobookshelfError: Error, Sendable {

        case notFound

        /// You do not have access to this library item, or you lack the required permission.
        case forbidden

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}
