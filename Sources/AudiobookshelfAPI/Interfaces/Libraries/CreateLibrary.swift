//
//  CreateLibrary.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Create a new library.
public struct CreateLibrary: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/libraries"

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public let body: RequestBody?

        public let authentication: AuthenticationType = .bearer

        /// Create Library Parameters
        ///
        /// - Parameters:
        ///   - name: The name of the library.
        ///   - folders: Array of folder paths for the library.
        ///   - icon: The icon for the library.
        ///   - mediaType: The media type of the library (book or podcast).
        ///   - provider: The metadata provider for the library.
        public init(
            name: String,
            folders: [String],
            icon: String? = nil,
            mediaType: String,
            provider: String? = nil
        ) {
            self.body = .json(
                Body(
                    name: name,
                    folders: folders,
                    icon: icon,
                    mediaType: mediaType,
                    provider: provider
                )
            )
        }

    }

    // MARK: Response

    public typealias Response = Library

    public enum AudiobookshelfError: Error {

        case forbidden

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        403: .failure(AudiobookshelfError.forbidden),

    ]

}

public extension CreateLibrary.Parameters {

    struct Body: Encodable, Sendable {

        let name: String

        let folders: [String]

        let icon: String?

        let mediaType: String

        let provider: String?

    }

}
