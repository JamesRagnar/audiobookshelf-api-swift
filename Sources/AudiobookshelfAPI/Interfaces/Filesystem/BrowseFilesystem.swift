//
//  BrowseFilesystem.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Browse the server filesystem.
public struct BrowseFilesystem: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String = "/api/filesystem"

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        public init(path: String? = nil) {
            var queryItems: [URLQueryItem] = []
            queryItems.appendIfPresent("path", path)
            self.queryItems = queryItems.isEmpty ? nil : queryItems
        }

    }

    // MARK: Response

    public typealias Response = BrowseFilesystemResponse

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(403, .error(AudiobookshelfError.forbidden))
        ]
    )

}

public extension BrowseFilesystem {

    struct BrowseFilesystemResponse: Decodable, Sendable, InterfaceResponse {

        public let posix: Bool

        public let directories: [Directory]

    }

    struct Directory: Decodable, Sendable {

        public let path: String

        public let dirname: String

        public let level: Int

    }

}
