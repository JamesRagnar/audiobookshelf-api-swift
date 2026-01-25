//
//  AddCustomMetadataProvider.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Add a new custom metadata provider.
public struct AddCustomMetadataProvider: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/custom-metadata-providers"

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        public init(
            name: String,
            url: String
        ) throws {
            self.body = try JSONEncoder().encode(
                Body(
                    name: name,
                    url: url
                )
            )
        }

    }

    // MARK: Response

    public typealias Response = CustomMetadataProvider

    public enum AudiobookshelfError: Error {

        case badRequest

        case forbidden

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        403: .failure(AudiobookshelfError.forbidden),

    ]

}

extension AddCustomMetadataProvider.Parameters {

    struct Body: Encodable {

        let name: String

        let url: String

    }

}
