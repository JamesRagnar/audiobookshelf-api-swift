//
//  EncodeLibraryItemM4B.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Encode an audiobook to M4B format.
public struct EncodeLibraryItemM4B: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        public init(
            itemId: String,
            bitrate: String? = nil,
            codec: String? = nil,
            channels: Int? = nil
        ) {
            self.path = "/api/tools/item/\(itemId)/encode-m4b"
            self.body = Payload(
                bitrate: bitrate,
                codec: codec,
                channels: channels
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

    public static let responseCases: ResponseMap = [

        .code(200, .noContent),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound)),
    ]

}

public extension EncodeLibraryItemM4B.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let bitrate: String?

        let codec: String?

        let channels: Int?

    }

}
