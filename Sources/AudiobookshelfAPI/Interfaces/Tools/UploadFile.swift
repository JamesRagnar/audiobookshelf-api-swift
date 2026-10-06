//
//  UploadFile.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Upload a file to the server.
public struct UploadFile: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String = "/api/upload"

        public let queryItems: [URLQueryItem]? = nil

        public typealias Body = BinaryBody

        public let body: Body

        public let headers: [String: String]?

        public let authentication: AuthenticationScheme? = .bearer

        public enum ValidationError: Error, Equatable, Sendable {

            case emptyFileData
            case invalidLibraryID
            case invalidFolderID
            case invalidTitle
            case invalidFilename
            case invalidMIMEType
            case boundaryGenerationFailed

        }

        /// Creates a valid single-file multipart upload.
        public init(
            fileData: Data,
            filename: String,
            mimeType: String,
            libraryId: String,
            folderId: String,
            title: String,
            author: String? = nil,
            series: String? = nil
        ) throws {
            try self.init(
                fileData: fileData,
                filename: filename,
                mimeType: mimeType,
                libraryId: libraryId,
                folderId: folderId,
                title: title,
                author: author,
                series: series,
                boundaryGenerator: { "abs-" + UUID().uuidString }
            )
        }

        init(
            fileData: Data,
            filename: String,
            mimeType: String,
            libraryId: String,
            folderId: String,
            title: String,
            author: String? = nil,
            series: String? = nil,
            boundaryGenerator: @escaping @Sendable () -> String
        ) throws {
            guard !fileData.isEmpty else { throw ValidationError.emptyFileData }
            guard MultipartValidation.isNonEmptyText(libraryId) else { throw ValidationError.invalidLibraryID }
            guard MultipartValidation.isNonEmptyText(folderId) else { throw ValidationError.invalidFolderID }
            guard MultipartValidation.isNonEmptyText(title),
                  !title.unicodeScalars.contains(where: MultipartValidation.isNUL) else {
                throw ValidationError.invalidTitle
            }
            guard MultipartValidation.isValidFilename(filename) else { throw ValidationError.invalidFilename }
            guard MultipartValidation.isValidMIMEType(mimeType) else { throw ValidationError.invalidMIMEType }

            let multipart: MultipartUploadBody
            do {
                multipart = try MultipartUploadBody(
                    fileData: fileData,
                    filename: filename,
                    mimeType: mimeType,
                    boundaryGenerator: boundaryGenerator,
                    fields: [
                        ("library", libraryId),
                        ("folder", folderId),
                        ("title", title),
                        ("author", author),
                        ("series", series)
                    ]
                )
            } catch {
                throw ValidationError.boundaryGenerationFailed
            }
            self.body = BinaryBody(data: multipart.data, contentType: multipart.contentType)
            self.headers = ["Content-Type": multipart.contentType]
        }

        /// Creates a raw upload body for source compatibility.
        ///
        /// - Important: `fileData` must already contain a complete multipart body. The legacy
        ///   library and folder arguments are retained for source compatibility and are unused.
        @available(
            *, deprecated,
            message: "Use the structured multipart initializer; legacy arguments are unused."
        )
        public init(
            fileData: Data,
            contentType: String,
            libraryId: String? = nil,
            folderId: String? = nil
        ) {
            self.body = BinaryBody(data: fileData, contentType: contentType)
            self.headers = nil
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

        case notFound

        case internalError

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound)),
            .code(500, .error(AudiobookshelfError.internalError))
        ]
    )

}
