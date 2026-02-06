//
//  CreatePodcastFromFeed.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2025-01-27.
//

import Foundation
import RagnarNetworking

/// Create a podcast from an RSS feed URL.
public struct CreatePodcastFromFeed: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/podcasts/feed"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        /// Create Podcast from Feed Parameters
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

    public typealias Response = LibraryItem

    public enum AudiobookshelfError: Error, Sendable {
        case badRequest
        case forbidden
        case notFound
    }

    public static let responseCases: ResponseMap = [
        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound)),
    ]
}

public extension CreatePodcastFromFeed.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {
        let rssFeed: String
        let libraryId: String
        let folderId: String
        let autoDownloadEpisodes: Bool?
    }

}
