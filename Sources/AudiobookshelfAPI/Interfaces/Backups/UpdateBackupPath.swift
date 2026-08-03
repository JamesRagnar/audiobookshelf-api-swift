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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .patch

        public let path: String = "/api/backups/path"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Update Backup Path Request
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

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden))
        ]
    )

}

public extension UpdateBackupPath.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let backupPath: String

    }

}
