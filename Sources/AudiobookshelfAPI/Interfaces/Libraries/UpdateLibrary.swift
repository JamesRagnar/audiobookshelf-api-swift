//
//  UpdateLibrary.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Update library configuration.
public struct UpdateLibrary: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationType = .bearer

        /// Update Library Parameters
        ///
        /// - Parameters:
        ///   - libraryId: The ID of the library to update.
        ///   - name: The new name of the library.
        ///   - folders: Array of folder paths for the library.
        ///   - icon: The icon for the library.
        ///   - provider: The metadata provider for the library.
        public init(
            libraryId: String,
            name: String? = nil,
            folders: [String]? = nil,
            icon: String? = nil,
            provider: String? = nil
        ) {
            self.path = "/api/libraries/\(libraryId)"
            self.body = Payload(
                name: name,
                folders: folders,
                icon: icon,
                provider: provider
            )
        }

    }

    // MARK: Response

    public typealias Response = Library

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

        /// The `limit` or `page` query parameter was not a non-negative integer.
        case badRequest

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}

public extension UpdateLibrary.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let name: String?

        let folders: [String]?

        let icon: String?

        let provider: String?

    }

}
