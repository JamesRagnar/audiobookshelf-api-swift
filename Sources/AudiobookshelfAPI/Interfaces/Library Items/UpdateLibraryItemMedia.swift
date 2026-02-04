//
//  UpdateLibraryItemMedia.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Update library item media metadata.
public struct UpdateLibraryItemMedia: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public let body: RequestBody?

        public let authentication: AuthenticationType = .bearer

        /// Update Library Item Media Parameters
        ///
        /// - Parameters:
        ///   - itemId: The ID of the library item.
        ///   - metadata: Dictionary of metadata fields to update.
        public init(
            itemId: String,
            metadata: [String: String]
        ) {
            self.path = "/api/items/\(itemId)/media"
            self.body = .json(metadata)
        }

    }

    // MARK: Response

    public typealias Response = LibraryItem

    public enum AudiobookshelfError: Error {

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        404: .failure(AudiobookshelfError.notFound),

    ]

}
