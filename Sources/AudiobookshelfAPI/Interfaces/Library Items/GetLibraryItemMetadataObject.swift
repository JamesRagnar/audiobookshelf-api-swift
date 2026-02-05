//
//  GetLibraryItemMetadataObject.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Get a library item's metadata object for external matching.
public struct GetLibraryItemMetadataObject: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil


        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        public init(itemId: String) {
            self.path = "/api/items/\(itemId)/metadata-object"
        }

    }

    // MARK: Response

    public typealias Response = Data

    public enum AudiobookshelfError: Error {

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        403: .failure(AudiobookshelfError.forbidden),

        404: .failure(AudiobookshelfError.notFound),

    ]

}
