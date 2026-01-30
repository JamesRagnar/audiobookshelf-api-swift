//
//  UpdateEbookFileStatus.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Update eBook file reading progress.
public struct UpdateEbookFileStatus: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        public init(
            itemId: String,
            fileId: String,
            ebookLocation: String? = nil,
            ebookProgress: Float? = nil
        ) throws {
            self.path = "/api/items/\(itemId)/ebook/\(fileId)/status"
            self.body = try JSONEncoder().encode(
                Body(
                    ebookLocation: ebookLocation,
                    ebookProgress: ebookProgress
                )
            )
        }

    }

    // MARK: Response

    public typealias Response = Data

    public enum AudiobookshelfError: Error {

        case badRequest

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        403: .failure(AudiobookshelfError.forbidden),

        404: .failure(AudiobookshelfError.notFound),

    ]

}

public extension UpdateEbookFileStatus.Parameters {

    struct Body: Encodable {

        let ebookLocation: String?

        let ebookProgress: Float?

    }

}
