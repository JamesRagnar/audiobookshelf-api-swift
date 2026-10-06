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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Update Library Request
        ///
        /// - Parameters:
        ///   - libraryId: The ID of the library to update.
        ///   - name: The new name of the library.
        ///   - folders: Complete replacement wire folders list (2.26.0+). Nil preserves all;
        ///     [] removes all folders and associated library items. Retain existing folders by ID.
        ///   - icon: The icon for the library.
        ///   - provider: The metadata provider for the library.
        ///   - mediaType: Optional wire mediaType, book or podcast; nil omits.
        ///   - displayOrder: Optional wire displayOrder integer; nil preserves.
        ///   - settings: Optional partial wire settings; nil preserves (2.26.0+).
        public init(
            libraryId: String,
            name: String? = nil,
            folders: [LibraryFolderUpdate]? = nil,
            icon: String? = nil,
            provider: String? = nil,
            mediaType: String? = nil,
            displayOrder: Int? = nil,
            settings: LibrarySettingsUpdate? = nil
        ) {
            self.path = "/api/libraries/\(libraryId)"
            self.body = Payload(
                name: name,
                folders: folders,
                icon: icon,
                provider: provider,
                mediaType: mediaType,
                displayOrder: displayOrder,
                settings: settings
            )
        }

    }

    // MARK: Response

    public typealias Response = Library

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

        /// Invalid library configuration payload.
        case badRequest

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}

public extension UpdateLibrary.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let name: String?

        let folders: [LibraryFolderUpdate]?

        let icon: String?

        let provider: String?
        let mediaType: String?
        let displayOrder: Int?
        let settings: LibrarySettingsUpdate?

    }

}
