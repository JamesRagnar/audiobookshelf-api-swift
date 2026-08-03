//
//  GetLibraryItem.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-20.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves a library item.
public struct GetLibraryItem: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public enum IncludeOption: String {

            case progress

            case rssfeed

            case authors

            case downloads

        }

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Get Library Item Request
        ///
        /// - Parameters:
        ///   - itemID: The ID of the library item to retrieve.
        ///   - expanded: Whether to return Library Item Expanded instead.
        /// - include: A list of what to include with the library item. expanded must be `true` for include to have an
        /// effect.
        ///   - episode: If requesting `progress` for a podcast, the episode ID to get progress for.
        public init(
            itemID: String,
            expanded: Bool? = nil,
            include: Set<IncludeOption>? = nil,
            episode: String? = nil
        ) {
            self.path = "/api/items/\(itemID)"

            var queryItems: [URLQueryItem] = []
            queryItems.appendIfPresent("expanded", expanded?.binaryString)
            queryItems.appendIfPresent("include", include?.joined())
            queryItems.appendIfPresent("episode", episode)
            self.queryItems = queryItems
        }

    }

    // MARK: Response

    public typealias Response = LibraryItem

    public enum AudiobookshelfError: Error, Sendable {

        /// You do not have access to this library item.
        case forbidden

        /// No library item exists with the given ID.
        case notFound

    }

    public static let responses = ResponseContract<Response>(
        /// Library Item or, if expanded was requested, Library Item Expanded with optional extra attributes.
        success: .exact(200),
        failures: [
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}
