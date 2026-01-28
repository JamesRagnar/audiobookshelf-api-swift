//
//  UploadBackup.swift
//  AudiobookshelfAPI
//
//  Created by Ragnar Henriksen on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Upload a backup file to the server.
public struct UploadBackup: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/backups/upload"

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        /// Upload Backup Parameters
        ///
        /// - Parameters:
        ///   - backupFile: The backup file data to upload.
        public init(backupFile: Data) {
            self.body = backupFile
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
