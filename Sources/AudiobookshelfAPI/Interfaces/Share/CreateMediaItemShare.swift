//
//  CreateMediaItemShare.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Create a share link for a media item.
public struct CreateMediaItemShare: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        public init(
            mediaItemId: String,
            expiresAt: Int? = nil
        ) throws {
            self.path = "/api/share/mediaitem/\(mediaItemId)"
            self.body = try JSONEncoder().encode(
                Body(expiresAt: expiresAt)
            )
        }

    }

    // MARK: Response

    public typealias Response = Share

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

extension CreateMediaItemShare.Parameters {

    struct Body: Encodable {

        let expiresAt: Int?

    }

}
