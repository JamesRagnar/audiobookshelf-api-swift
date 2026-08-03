//
//  GetLibraryItemMetadataObject.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Get a library item's metadata object for external matching.
public struct GetLibraryItemMetadataObject: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        public init(itemId: String) {
            self.path = "/api/items/\(itemId)/metadata-object"
        }

    }

    // MARK: Response

    public typealias Response = JSONValue

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}
