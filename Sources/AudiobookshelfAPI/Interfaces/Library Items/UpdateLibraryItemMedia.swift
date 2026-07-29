//
//  UpdateLibraryItemMedia.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Update library item media metadata.
public struct UpdateLibraryItemMedia: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = LibraryItemMediaPayload

        public let body: Body

        public let authentication: AuthenticationType = .bearer

        /// Update Library Item Media Parameters
        ///
        /// - Parameters:
        ///   - itemId: The ID of the library item.
        ///   - mediaPayload: Media payload to update (metadata, tags, podcast settings, etc).
        public init(
            itemId: String,
            mediaPayload: LibraryItemMediaPayload
        ) {
            self.path = "/api/items/\(itemId)/media"
            self.body = mediaPayload
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let updated: Bool

        public let libraryItem: LibraryItem

    }

    public enum AudiobookshelfError: Error, Sendable {

        case notFound

        /// You do not have access to this library item, or you lack the required permission.
        case forbidden

    }

    public static let responseCases: ResponseMap = [
        .code(200, .decode),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound))
    ]

}

public extension UpdateLibraryItemMedia.Parameters {

    struct LibraryItemMediaPayload: RequestBody, Encodable, Sendable {
        public let metadata: LibraryItemMediaMetadata?
        public let tags: [String]?
        public let autoDownloadEpisodes: Bool?
        public let autoDownloadSchedule: String?
        public let lastEpisodeCheck: Int?
        public let maxEpisodesToKeep: Int?
        public let maxNewEpisodesToDownload: Int?
        public let url: String?

        public init(
            metadata: LibraryItemMediaMetadata? = nil,
            tags: [String]? = nil,
            autoDownloadEpisodes: Bool? = nil,
            autoDownloadSchedule: String? = nil,
            lastEpisodeCheck: Int? = nil,
            maxEpisodesToKeep: Int? = nil,
            maxNewEpisodesToDownload: Int? = nil,
            url: String? = nil
        ) {
            self.metadata = metadata
            self.tags = tags
            self.autoDownloadEpisodes = autoDownloadEpisodes
            self.autoDownloadSchedule = autoDownloadSchedule
            self.lastEpisodeCheck = lastEpisodeCheck
            self.maxEpisodesToKeep = maxEpisodesToKeep
            self.maxNewEpisodesToDownload = maxNewEpisodesToDownload
            self.url = url
        }
    }

    struct LibraryItemMediaMetadata: Encodable, Sendable {
        public let title: String?
        public let subtitle: String?
        public let authors: [LibraryItemMediaAuthorPayload]?
        public let narrators: [String]?
        public let series: [LibraryItemMediaSeriesPayload]?
        public let genres: [String]?
        public let publishedYear: String?
        public let publishedDate: String?
        public let publisher: String?
        public let description: String?
        public let isbn: String?
        public let asin: String?
        public let language: String?
        public let explicit: Bool?
        public let abridged: Bool?
        public let author: String?
        public let releaseDate: String?
        public let feedUrl: String?
        public let imageUrl: String?
        public let itunesPageUrl: String?
        public let itunesId: String?
        public let itunesArtistId: String?
        public let type: String?

        public init(
            title: String? = nil,
            subtitle: String? = nil,
            authors: [LibraryItemMediaAuthorPayload]? = nil,
            narrators: [String]? = nil,
            series: [LibraryItemMediaSeriesPayload]? = nil,
            genres: [String]? = nil,
            publishedYear: String? = nil,
            publishedDate: String? = nil,
            publisher: String? = nil,
            description: String? = nil,
            isbn: String? = nil,
            asin: String? = nil,
            language: String? = nil,
            explicit: Bool? = nil,
            abridged: Bool? = nil,
            author: String? = nil,
            releaseDate: String? = nil,
            feedUrl: String? = nil,
            imageUrl: String? = nil,
            itunesPageUrl: String? = nil,
            itunesId: String? = nil,
            itunesArtistId: String? = nil,
            type: String? = nil
        ) {
            self.title = title
            self.subtitle = subtitle
            self.authors = authors
            self.narrators = narrators
            self.series = series
            self.genres = genres
            self.publishedYear = publishedYear
            self.publishedDate = publishedDate
            self.publisher = publisher
            self.description = description
            self.isbn = isbn
            self.asin = asin
            self.language = language
            self.explicit = explicit
            self.abridged = abridged
            self.author = author
            self.releaseDate = releaseDate
            self.feedUrl = feedUrl
            self.imageUrl = imageUrl
            self.itunesPageUrl = itunesPageUrl
            self.itunesId = itunesId
            self.itunesArtistId = itunesArtistId
            self.type = type
        }
    }

    struct LibraryItemMediaAuthorPayload: Encodable, Sendable {
        public let name: String

        public init(name: String) {
            self.name = name
        }
    }

    struct LibraryItemMediaSeriesPayload: Encodable, Sendable {
        public let name: String
        public let sequence: String?

        public init(name: String, sequence: String? = nil) {
            self.name = name
            self.sequence = sequence
        }
    }

}
