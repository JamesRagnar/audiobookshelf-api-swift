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
