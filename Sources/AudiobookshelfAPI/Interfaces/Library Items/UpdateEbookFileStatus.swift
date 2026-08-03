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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        public init(
            itemId: String,
            fileId: String,
            ebookLocation: String? = nil,
            ebookProgress: Float? = nil
        ) {
            self.path = "/api/items/\(itemId)/ebook/\(fileId)/status"
            self.body = Payload(
                ebookLocation: ebookLocation,
                ebookProgress: ebookProgress
            )
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}

public extension UpdateEbookFileStatus.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let ebookLocation: String?

        let ebookProgress: Float?

    }

}
