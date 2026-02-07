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

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/api/filesystem"

        public let queryItems: [String: String?]?

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        public init(path: String? = nil) {
            if let path = path {
                self.queryItems = ["path": path]
            } else {
                self.queryItems = nil
            }
        }

    }

    // MARK: Response

    public typealias Response = BrowseFilesystemResponse

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(403, .error(AudiobookshelfError.forbidden))
    ]

}

public extension BrowseFilesystem {

    struct BrowseFilesystemResponse: Decodable, Sendable {

        public let posix: Bool

        public let directories: [Directory]

    }

    struct Directory: Decodable, Sendable {

        public let path: String

        public let dirname: String

        public let level: Int

    }

}
