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

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body?

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

    public enum AudiobookshelfError: Error {

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        403: .failure(AudiobookshelfError.forbidden),

        404: .failure(AudiobookshelfError.notFound)

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
