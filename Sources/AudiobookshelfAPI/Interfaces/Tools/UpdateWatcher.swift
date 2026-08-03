//
//  UpdateWatcher.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Manually trigger watcher events for file system changes.
public struct UpdateWatcher: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String = "/api/watcher/update"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Update Watcher Request
        ///
        /// - Parameters:
        ///   - libraryId: The ID of the library.
        ///   - path: The file path that changed.
        ///   - type: The type of change ("add", "unlink", or "rename").
        ///   - oldPath: The old path (required only for "rename" type).
        public init(
            libraryId: String,
            path: String,
            type: String,
            oldPath: String? = nil
        ) {
            self.body = Payload(
                libraryId: libraryId,
                path: path,
                type: type,
                oldPath: oldPath
            )
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden))
        ]
    )

}

public extension UpdateWatcher.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let libraryId: String

        let path: String

        let type: String

        let oldPath: String?

    }

}
