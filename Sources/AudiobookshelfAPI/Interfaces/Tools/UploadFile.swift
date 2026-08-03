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

        public let headers: [String: String]? = nil

        public typealias Body = BinaryBody

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        public init(
            fileData: Data,
            contentType: String,
            libraryId: String? = nil,
            folderId: String? = nil
        ) {
            self.body = BinaryBody(data: fileData, contentType: contentType)
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
