//
//  RemoveLibraryItemCover.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Remove cover image from a library item.
public struct RemoveLibraryItemCover: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public typealias Body = EmptyBody

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Remove Library Item Cover Parameters
        ///
        /// - Parameter itemId: The ID of the library item.
        public init(itemId: String) {
            self.path = "/api/items/\(itemId)/cover"
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
