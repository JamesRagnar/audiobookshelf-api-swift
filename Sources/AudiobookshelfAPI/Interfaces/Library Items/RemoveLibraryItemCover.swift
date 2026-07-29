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

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// Remove Library Item Cover Parameters
        ///
        /// - Parameter itemId: The ID of the library item.
        public init(itemId: String) {
            self.path = "/api/items/\(itemId)/cover"
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case notFound

        /// You do not have access to this library item, or you lack the required permission.
        case forbidden

    }

    public static let responseCases: ResponseMap = [
        .code(200, .noContent),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}
