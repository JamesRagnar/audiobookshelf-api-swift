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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String = "/api/libraries"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Create Library Request
        ///
        /// - Parameters:
        ///   - name: The name of the library.
        ///   - folders: Array of folder paths for the library.
        ///   - icon: The icon for the library.
        ///   - mediaType: The media type of the library (book or podcast).
        ///   - provider: The metadata provider for the library.
        ///   - settings: Optional wire settings object; nil omits. Creation applies defaults (2.26.0+).
        public init(
            name: String,
            folders: [String],
            icon: String? = nil,
            mediaType: String,
            provider: String? = nil,
            settings: LibrarySettingsUpdate? = nil
        ) {
            self.body = Payload(
                name: name,
                folders: folders.map { FolderPath(path: $0) },
                icon: icon,
                mediaType: mediaType,
                provider: provider,
                settings: settings
            )
        }

    }

    // MARK: Response

    public typealias Response = Library

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case internalServerError

        case forbidden

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(500, .error(AudiobookshelfError.internalServerError))
        ]
    )

}

public extension CreateLibrary.Request {

    /// Creation-only folder object with required wire path (2.26.0+).
    struct FolderPath: Encodable, Sendable {
        /// Required server-local folder path.
        public let path: String
        /// Creates a folder object; path is always transmitted.
        public init(path: String) { self.path = path }
    }

    struct Payload: RequestBody, Encodable, Sendable {

        let name: String

        let folders: [FolderPath]

        let icon: String?

        let mediaType: String

        let provider: String?

        let settings: LibrarySettingsUpdate?

    }

}
