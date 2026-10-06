//
//  UploadLibraryItemCover.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Upload a cover image for a library item.
public struct UploadLibraryItemCover: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String

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
        ///   - itemId: Required library-item ID.
        ///   - imageData: Required nonempty exact file bytes.
        ///   - filename: Required safe filename ending in png, jpg, jpeg or webp.
        ///   - contentType: Required part MIME type; must not contain parameters or header controls.
        public init(
            itemId: String,
            imageData: Data,
            filename: String,
            contentType: String
        ) throws {
            try self.init(
                itemId: itemId, imageData: imageData, filename: filename, contentType: contentType,
                boundaryGenerator: { "abs-" + UUID().uuidString }
            )
        }

        init(
            itemId: String,
            imageData: Data,
            filename: String,
            contentType: String,
            boundaryGenerator: @escaping @Sendable () -> String
        ) throws {
            guard !imageData.isEmpty else { throw ValidationError.emptyFileData }
            guard MultipartValidation.isValidFilename(filename),
                  ["png", "jpg", "jpeg", "webp"].contains((filename as NSString).pathExtension.lowercased())
            else { throw ValidationError.invalidFilename }
            guard MultipartValidation.isValidMIMEType(contentType) else { throw ValidationError.invalidMIMEType }
            let multipart: MultipartUploadBody
            do {
                multipart = try MultipartUploadBody(
                    fileData: imageData, filename: filename, mimeType: contentType,
                    boundaryGenerator: boundaryGenerator, fields: [], partName: "cover"
                )
            } catch {
                throw ValidationError.boundaryGenerationFailed
            }
            self.path = "/api/items/\(itemId)/cover"
            self.body = BinaryBody(data: multipart.data, contentType: multipart.contentType)
            self.headers = ["Content-Type": multipart.contentType]
        }

        /// Legacy bytes must already be a complete multipart body, with a matching boundary in Content-Type.
        @available(*, deprecated, message: "Use the structured multipart initializer with filename.")
        public init(itemId: String, imageData: Data, contentType: String) {
            self.path = "/api/items/\(itemId)/cover"
            self.body = BinaryBody(data: imageData, contentType: contentType)
            self.headers = nil
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// Required wire success on 2.26.0+.
        public let success: Bool

        /// Required selected artwork path, wire cover (2.26.0+).
        public let cover: String

    }

    public enum AudiobookshelfError: Error, Sendable {

        case internalError

        case badRequest

        case forbidden

        case notFound

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
