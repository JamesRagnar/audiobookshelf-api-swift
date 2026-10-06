//
//  UploadBackup.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Upload a backup file to the server.
public struct UploadBackup: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String = "/api/backups/upload"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]?

        public typealias Body = BinaryBody

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Structured multipart validation failures; wrong extensions use invalidFilename.
        public enum ValidationError: Error, Equatable, Sendable {
            case emptyFileData
            case invalidFilename
            case invalidMIMEType
            case boundaryGenerationFailed
        }

        /// Creates a complete single-part multipart write on 2.26.0+.
        /// - Parameters:
        ///   - backupFile: Required nonempty exact file bytes.
        ///   - filename: Required safe filename ending in lowercase .audiobookshelf.
        ///   - mimeType: Required part MIME type; must not contain parameters or header controls.
        public init(
            backupFile: Data,
            filename: String,
            mimeType: String = "application/octet-stream"
        ) throws {
            try self.init(
                backupFile: backupFile, filename: filename, mimeType: mimeType,
                boundaryGenerator: { "abs-" + UUID().uuidString }
            )
        }

        init(
            backupFile: Data,
            filename: String,
            mimeType: String = "application/octet-stream",
            boundaryGenerator: @escaping @Sendable () -> String
        ) throws {
            guard !backupFile.isEmpty else { throw ValidationError.emptyFileData }
            guard MultipartValidation.isValidFilename(filename),
                  filename.hasSuffix(".audiobookshelf")
            else { throw ValidationError.invalidFilename }
            guard MultipartValidation.isValidMIMEType(mimeType) else { throw ValidationError.invalidMIMEType }
            let multipart: MultipartUploadBody
            do {
                multipart = try MultipartUploadBody(
                    fileData: backupFile, filename: filename, mimeType: mimeType,
                    boundaryGenerator: boundaryGenerator, fields: [], partName: "file"
                )
            } catch {
                throw ValidationError.boundaryGenerationFailed
            }
            self.body = BinaryBody(data: multipart.data, contentType: multipart.contentType)
            self.headers = ["Content-Type": multipart.contentType]
        }

        /// Legacy raw upload on 2.26.0+.
        /// - Parameters:
        ///   - backupFile: Must already contain a complete multipart body.
        ///   - mimeType: Must be multipart/form-data with the matching boundary.
        ///     The retained application/octet-stream default does not construct a valid multipart upload.
        @available(*, deprecated, message: "Use the structured multipart initializer with filename.")
        public init(backupFile: Data, mimeType: String = "application/octet-stream") {
            self.body = BinaryBody(data: backupFile, contentType: mimeType)
            self.headers = nil
        }

    }

    // MARK: Response

    public typealias Response = BackupsResponse

    public enum AudiobookshelfError: Error, Sendable {

        case internalError

        case badRequest

        case forbidden

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(500, .error(AudiobookshelfError.internalError))
        ]
    )

}
