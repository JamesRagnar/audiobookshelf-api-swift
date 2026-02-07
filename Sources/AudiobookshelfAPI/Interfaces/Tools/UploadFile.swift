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

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/upload"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = BinaryBody

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

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

    public static let responseCases: ResponseMap = [

        .code(200, .noContent),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden)),
    ]

}
