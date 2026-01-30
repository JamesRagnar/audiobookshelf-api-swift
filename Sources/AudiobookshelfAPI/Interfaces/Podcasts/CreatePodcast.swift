//
//  CreatePodcast.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2025-01-27.
//

import Foundation
import RagnarNetworking

/// Create a new podcast in a library.
public struct CreatePodcast: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/podcasts"

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        /// Create Podcast Parameters
        ///
        /// - Parameters:
        ///   - libraryId: The ID of the library.
        ///   - folderId: The folder ID within the library.
        ///   - path: Full filesystem path for the podcast folder.
        ///   - metadata: Podcast metadata.
        public init(
            libraryId: String,
            folderId: String,
            path: String,
            metadata: PodcastMetadataPayload
        ) throws {
            self.body = try JSONEncoder().encode(
                Body(
                    libraryId: libraryId,
                    folderId: folderId,
                    path: path,
                    media: MediaPayload(metadata: metadata)
                )
            )
        }
    }

    // MARK: Response

    public typealias Response = LibraryItem

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

public extension CreatePodcast.Parameters {

    struct Body: Encodable {
        let libraryId: String
        let folderId: String
        let path: String
        let media: MediaPayload
    }

    struct MediaPayload: Encodable {
        let metadata: PodcastMetadataPayload
    }

    struct PodcastMetadataPayload: Encodable {
        let title: String?
        let author: String?
        let description: String?
        let releaseDate: String?
        let genres: [String]?
        let feedUrl: String?
        let imageUrl: String?
        let itunesPageUrl: String?
        let itunesId: String?
        let itunesArtistId: String?
        let language: String?
        let explicit: Bool?
        let type: String?

        public init(
            title: String? = nil,
            author: String? = nil,
            description: String? = nil,
            releaseDate: String? = nil,
            genres: [String]? = nil,
            feedUrl: String? = nil,
            imageUrl: String? = nil,
            itunesPageUrl: String? = nil,
            itunesId: String? = nil,
            itunesArtistId: String? = nil,
            language: String? = nil,
            explicit: Bool? = nil,
            type: String? = nil
        ) {
            self.title = title
            self.author = author
            self.description = description
            self.releaseDate = releaseDate
            self.genres = genres
            self.feedUrl = feedUrl
            self.imageUrl = imageUrl
            self.itunesPageUrl = itunesPageUrl
            self.itunesId = itunesId
            self.itunesArtistId = itunesArtistId
            self.language = language
            self.explicit = explicit
            self.type = type
        }
    }

}
