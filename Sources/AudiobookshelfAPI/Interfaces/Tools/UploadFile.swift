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
            guard Self.isNonEmptyText(libraryId) else { throw ValidationError.invalidLibraryID }
            guard Self.isNonEmptyText(folderId) else { throw ValidationError.invalidFolderID }
            guard Self.isNonEmptyText(title), !title.unicodeScalars.contains(where: Self.isNUL) else {
                throw ValidationError.invalidTitle
            }
            guard Self.isValidFilename(filename) else { throw ValidationError.invalidFilename }
            guard Self.isValidMIMEType(mimeType) else { throw ValidationError.invalidMIMEType }

            let multipart = try MultipartUploadBody(
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
            self.body = BinaryBody(data: multipart.data, contentType: multipart.contentType)
            self.headers = ["Content-Type": multipart.contentType]
        }

        /// Creates a raw upload body for source compatibility.
        ///
        /// - Important: `fileData` must already contain a complete multipart body. The legacy
        ///   library and folder arguments are retained for source compatibility and are unused.
        @available(*, deprecated, message: "Use init(fileData:filename:mimeType:libraryId:folderId:title:author:series:) for structured multipart uploads. This initializer requires a complete multipart body and its ID arguments are unused.")
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

private extension UploadFile.Request {

    static func isNUL(_ scalar: Unicode.Scalar) -> Bool {
        scalar.value == 0
    }

    static func isNonEmptyText(_ value: String) -> Bool {
        !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !value.unicodeScalars.contains(where: isNUL)
    }

    static func isValidFilename(_ value: String) -> Bool {
        guard !value.isEmpty, value != ".", value != ".." else { return false }
        guard !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        return !value.unicodeScalars.contains { scalar in
            scalar == "/" || scalar == "\\" || scalar == "\"" ||
                scalar.value == 0 || scalar.value == 0x7F || scalar.value == 0x0D || scalar.value == 0x0A ||
                (0x01...0x1F).contains(scalar.value)
        }
    }

    static func isValidMIMEType(_ value: String) -> Bool {
        let parts = value.split(separator: "/", omittingEmptySubsequences: false)
        guard parts.count == 2 else { return false }
        let separators = "()<>@,;:\\\"/[]?={} \t"
        return parts.allSatisfy { part in
            !part.isEmpty && part.unicodeScalars.allSatisfy { scalar in
                scalar.value >= 0x21 && scalar.value <= 0x7E && !separators.unicodeScalars.contains(scalar)
            }
        }
    }

}

private struct MultipartUploadBody: Sendable {

    let data: Data
    let contentType: String

    init(
        fileData: Data,
        filename: String,
        mimeType: String,
        boundaryGenerator: @escaping @Sendable () -> String,
        fields: [(String, String?)]
    ) throws(UploadFile.Request.ValidationError) {
        for _ in 0..<8 {
            let boundary = boundaryGenerator()
            let data = Self.makeData(
                boundary: boundary,
                fileData: fileData,
                filename: filename,
                mimeType: mimeType,
                fields: fields
            )
            let boundaryData = Data(boundary.utf8)
            let headerData = Data(("form-data; name=\"file\"; filename=\"\(filename)\"\r\nContent-Type: \(mimeType)").utf8)
            let values = fields.compactMap(\.1).map { Data($0.utf8) }
            let collides = values.contains { $0.range(of: boundaryData) != nil } ||
                fileData.range(of: boundaryData) != nil ||
                headerData.range(of: boundaryData) != nil
            if !collides {
                self.data = data
                self.contentType = "multipart/form-data; boundary=\(boundary)"
                return
            }
        }
        throw .boundaryGenerationFailed
    }

    private static func makeData(
        boundary: String,
        fileData: Data,
        filename: String,
        mimeType: String,
        fields: [(String, String?)]
    ) -> Data {
        var data = Data()
        let prefix = Data("--\(boundary)\r\n".utf8)
        for (name, value) in fields {
            guard let value else { continue }
            data.append(prefix)
            data.append(Data("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".utf8))
            data.append(Data(value.utf8))
            data.append(Data("\r\n".utf8))
        }
        data.append(prefix)
        data.append(Data("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".utf8))
        data.append(Data("Content-Type: \(mimeType)\r\n\r\n".utf8))
        data.append(fileData)
        data.append(Data("\r\n--\(boundary)--\r\n".utf8))
        return data
    }

}
