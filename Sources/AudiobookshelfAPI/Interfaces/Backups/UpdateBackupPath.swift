//
//  UpdateBackupPath.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Update the backup storage path.
public struct UpdateBackupPath: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String = "/api/backups/path"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationType = .bearer

        /// Update Backup Path Parameters
        ///
        /// - Parameters:
        ///   - backupPath: The new file system path for storing backups.
        public init(backupPath: String) {
            self.body = Payload(backupPath: backupPath)
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

    }

    public static let responseCases: ResponseMap = [

        .code(200, .noContent),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden))
    ]

}

public extension UpdateBackupPath.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let backupPath: String

    }

}
