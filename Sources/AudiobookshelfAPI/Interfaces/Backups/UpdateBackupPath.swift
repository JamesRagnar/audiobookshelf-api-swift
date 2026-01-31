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

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        /// Update Backup Path Parameters
        ///
        /// - Parameters:
        ///   - backupPath: The new file system path for storing backups.
        public init(backupPath: String) throws {
            self.body = try JSONEncoder().encode(Body(backupPath: backupPath))
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

public extension UpdateBackupPath.Parameters {

    struct Body: Encodable {

        let backupPath: String

    }

}
