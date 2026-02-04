//
//  LibraryItemMediaPayload.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-02-03.
//

import Foundation
import RagnarNetworking

public struct LibraryItemMediaPayload: RequestBody, Encodable, Sendable {
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

public struct LibraryItemMediaMetadata: Encodable, Sendable {
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

public struct LibraryItemMediaAuthorPayload: Encodable, Sendable {
    public let name: String

    public init(name: String) {
        self.name = name
    }
}

public struct LibraryItemMediaSeriesPayload: Encodable, Sendable {
    public let name: String
    public let sequence: String?

    public init(name: String, sequence: String? = nil) {
        self.name = name
        self.sequence = sequence
    }
}
