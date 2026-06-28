//
//  DeleteBackup.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Delete a backup.
public struct DeleteBackup: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// Delete Backup Parameters
        ///
        /// - Parameter backupId: The ID of the backup to delete.
        public init(backupId: String) {
            self.path = "/api/backups/\(backupId)"
        }

    }

    // MARK: Response

    public typealias Response = BackupsResponse

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}
