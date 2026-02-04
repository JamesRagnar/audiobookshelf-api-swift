//
//  CreatePodcastsFromOPML.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Bulk create podcasts from OPML RSS feed URLs.
public struct CreatePodcastsFromOPML: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/podcasts/opml/create"

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public typealias Body = Payload

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        /// Create Podcasts From OPML Parameters
        ///
        /// - Parameters:
        ///   - feeds: Array of RSS feed URLs.
        ///   - libraryId: The ID of the library to add podcasts to.
        ///   - folderId: The ID of the folder within the library.
        ///   - autoDownloadEpisodes: Whether to enable auto-download for episodes.
        public init(
            feeds: [String],
            libraryId: String,
            folderId: String,
            autoDownloadEpisodes: Bool = false
        ) {
            self.body = Payload(
                feeds: feeds,
                libraryId: libraryId,
                folderId: folderId,
                autoDownloadEpisodes: autoDownloadEpisodes
            )
        }

    }

    // MARK: Response

    public typealias Response = Data

    public enum AudiobookshelfError: Error {

        case badRequest

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        403: .failure(AudiobookshelfError.forbidden),

        404: .failure(AudiobookshelfError.notFound)

    ]

}

public extension CreatePodcastsFromOPML.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let feeds: [String]

        let libraryId: String

        let folderId: String

        let autoDownloadEpisodes: Bool

    }

}
