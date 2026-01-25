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

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        public init(
            itemId: String,
            bitrate: String? = nil,
            codec: String? = nil,
            channels: Int? = nil
        ) throws {
            self.path = "/api/tools/item/\(itemId)/encode-m4b"
            self.body = try JSONEncoder().encode(
                Body(
                    bitrate: bitrate,
                    codec: codec,
                    channels: channels
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

extension EncodeLibraryItemM4B.Parameters {

    struct Body: Encodable {

        let bitrate: String?

        let codec: String?

        let channels: Int?

    }

}
