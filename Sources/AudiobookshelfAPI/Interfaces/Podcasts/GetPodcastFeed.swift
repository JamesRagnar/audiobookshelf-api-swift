//
//  GetPodcastFeed.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2025-01-27.
//

import Foundation
import RagnarNetworking

/// Fetch and parse a podcast's RSS feed.
///
/// This does not create anything. It returns the parsed feed so a client can preview it before
/// calling `CreatePodcast`.
public struct GetPodcastFeed: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String = "/api/podcasts/feed"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Create Podcast from Feed Request
        ///
        /// - Parameters:
        ///   - rssFeed: The RSS feed URL.
        ///   - libraryId: The ID of the library.
        ///   - folderId: The folder ID within the library.
        ///   - autoDownloadEpisodes: Whether to auto-download new episodes (optional).
        public init(
            rssFeed: String,
            libraryId: String,
            folderId: String,
            autoDownloadEpisodes: Bool? = nil
        ) {
            self.body = Payload(
                rssFeed: rssFeed,
                libraryId: libraryId,
                folderId: folderId,
                autoDownloadEpisodes: autoDownloadEpisodes
            )
        }
    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// The parsed RSS feed.
        public let podcast: PodcastFeed

    }

    public enum AudiobookshelfError: Error, Sendable {
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

public extension GetPodcastFeed.Request {

    struct Payload: RequestBody, Encodable, Sendable {
        let rssFeed: String
        let libraryId: String
        let folderId: String
        let autoDownloadEpisodes: Bool?
    }

}

/// The previous name for ``GetPodcastFeed``, which described the endpoint incorrectly.
@available(*, deprecated, renamed: "GetPodcastFeed")
public typealias CreatePodcastFromFeed = GetPodcastFeed
