//
//  MatchLibraryItem.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Match a library item with external metadata provider.
public struct MatchLibraryItem: Interface {

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
            provider: String,
            title: String? = nil,
            author: String? = nil,
            isbn: String? = nil,
            asin: String? = nil
        ) throws {
            self.path = "/api/items/\(itemId)/match"
            self.body = try JSONEncoder().encode(
                Body(
                    provider: provider,
                    title: title,
                    author: author,
                    isbn: isbn,
                    asin: asin
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

extension MatchLibraryItem.Parameters {

    struct Body: Encodable {

        let provider: String

        let title: String?

        let author: String?

        let isbn: String?

        let asin: String?

    }

}
