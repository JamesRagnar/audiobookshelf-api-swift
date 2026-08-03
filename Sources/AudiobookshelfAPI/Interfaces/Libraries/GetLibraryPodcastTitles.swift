//
//  GetLibraryPodcastTitles.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Get all podcast titles in a library.
public struct GetLibraryPodcastTitles: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        public init(libraryId: String) {
            self.path = "/api/libraries/\(libraryId)/podcast-titles"
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// The podcasts in the library.
        public let podcasts: [PodcastTitle]

        public struct PodcastTitle: Decodable, Sendable {

            /// The title of the podcast.
            public let title: String?

            /// The iTunes ID of the podcast. Null if the podcast was not matched against iTunes.
            public let itunesId: String?

            /// The ID of the library item the podcast belongs to.
            public let libraryItemId: String

            /// The ID of the library the podcast belongs to.
            public let libraryId: String

        }

    }

    public enum AudiobookshelfError: Error, Sendable {

        /// The `limit` or `page` query parameter was not a non-negative integer.
        case badRequest

        case forbidden

        case notFound

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
