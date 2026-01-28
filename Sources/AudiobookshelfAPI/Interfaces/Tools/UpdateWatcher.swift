//
//  UpdateWatcher.swift
//  AudiobookshelfAPI
//
//  Created by Ragnar Henriksen on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Manually trigger watcher events for file system changes.
public struct UpdateWatcher: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/watcher/update"

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        /// Update Watcher Parameters
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
        ) throws {
            self.body = try JSONEncoder().encode(
                Body(
                    libraryId: libraryId,
                    path: path,
                    type: type,
                    oldPath: oldPath
                )
            )
        }

    }

    // MARK: Response

    public typealias Response = Data

    public enum AudiobookshelfError: Error {

        case badRequest

        case forbidden

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        403: .failure(AudiobookshelfError.forbidden)

    ]

}

extension UpdateWatcher.Parameters {

    struct Body: Encodable {

        let libraryId: String

        let path: String

        let type: String

        let oldPath: String?

    }

}
