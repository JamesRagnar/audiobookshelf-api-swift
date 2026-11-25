//
//  MediaProgress.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-17.
//

import Foundation

public struct MediaProgress {

    /// Opaque progress-record identifier returned by the server. This is distinct from the
    /// library-item, episode, and media-item identifiers. Use it when removing this record.
    public let id: String

    /// The ID of the user the media progress is for.
    public let userId: String

    /// The ID of the library item the media progress is of.
    public let libraryItemId: String?

    /// The ID of the podcast episode the media progress is of. Will be null if the progress is for a book.
    public let episodeId: String?

    /// The ID of the media item.
    public let mediaItemId: String

    /// The type of the media item (book or podcastEpisode).
    public let mediaItemType: String

    /// Stored audio duration in seconds. The value depends on prior state and supplied writes;
    /// marking the record finished does not establish its duration.
    public let duration: Float

    /// Legacy serialized progress value. Marking finished can set this to 1 without moving
    /// audio time, so it need not equal `currentTime / duration`.
    public let progress: Float

    /// Stored audio position in seconds, independent of the ebook position. Completion-only
    /// writes need not move this position; other updates can reset it.
    public let currentTime: Float

    /// Stored ebook locator, independent of audio time. The server does not attach a file or
    /// edition identifier or enforce an EPUB-specific locator syntax.
    public let ebookLocation: String?

    /// Stored ebook fraction, conventionally 0 through 1. It does not imply record completion.
    public let ebookProgress: Float?

    /// Shared record completion, rather than independent audio and ebook completion flags.
    public let isFinished: Bool

    /// Shared record visibility on the server's continuation shelves.
    public let hideFromContinueListening: Bool

    /// Aggregate record update time in milliseconds since the POSIX epoch, shared by both formats.
    public let lastUpdate: Int

    /// Record creation time in milliseconds since the POSIX epoch. Creation requests use `createdAt`.
    public let startedAt: Int

    /// Shared completion time in milliseconds since the POSIX epoch, or nil when unfinished.
    public let finishedAt: Int?

    /// Optional administrator GetUser enrichment, wire displayTitle (2.26.0+).
    /// Missing/null means not included.
    public let displayTitle: String?

    /// Optional administrator GetUser enrichment, wire displaySubtitle (2.26.0+).
    /// Missing/null means not included.
    public let displaySubtitle: String?

    /// Optional administrator GetUser enrichment, wire coverPath (2.26.0+).
    /// Missing/null means not included.
    public let coverPath: String?

    /// Optional administrator GetUser enrichment, wire mediaUpdatedAt (2.26.0+).
    /// Missing/null means not included. ISO-8601, unlike the integer progress timestamps.
    public let mediaUpdatedAt: Date?

    // MARK: Media Progress With Media

    /// The media of the library item the media progress is for.
    /// - Note: Media Progress with Media - Added Attribute
    public let media: Media?

    /// The podcast episode the media progress is for. Will only exist if the media progress is for a podcast episode.
    /// - Note: Media Progress with Media - Added Attribute
    public let episode: PodcastEpisode?

}

extension MediaProgress {

    public enum Media {
        case book(Book)
        case podcast(Podcast)
    }
}

extension MediaProgress.Media: Sendable {}

extension MediaProgress: Decodable {

    enum CodingKeys: CodingKey {
        case id
        case userId
        case libraryItemId
        case episodeId
        case mediaItemId
        case mediaItemType
        case duration
        case progress
        case currentTime
        case ebookLocation
        case ebookProgress
        case isFinished
        case hideFromContinueListening
        case lastUpdate
        case startedAt
        case finishedAt
        case media
        case episode
        case displayTitle
        case displaySubtitle
        case coverPath
        case mediaUpdatedAt
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        userId = try container.decode(String.self, forKey: .userId)
        libraryItemId = try container.decodeIfPresent(String.self, forKey: .libraryItemId)
        episodeId = try container.decodeIfPresent(String.self, forKey: .episodeId)
        mediaItemId = try container.decode(String.self, forKey: .mediaItemId)
        mediaItemType = try container.decode(String.self, forKey: .mediaItemType)
        duration = try container.decode(Float.self, forKey: .duration)
        progress = try container.decode(Float.self, forKey: .progress)
        currentTime = try container.decode(Float.self, forKey: .currentTime)
        ebookLocation = try container.decodeIfPresent(String.self, forKey: .ebookLocation)
        ebookProgress = try container.decodeIfPresent(Float.self, forKey: .ebookProgress)
        isFinished = try container.decode(Bool.self, forKey: .isFinished)
        hideFromContinueListening = try container.decode(Bool.self, forKey: .hideFromContinueListening)
        lastUpdate = try container.decode(Int.self, forKey: .lastUpdate)
        startedAt = try container.decode(Int.self, forKey: .startedAt)
        finishedAt = try container.decodeIfPresent(Int.self, forKey: .finishedAt)
        displayTitle = try container.decodeIfPresent(String.self, forKey: .displayTitle)
        displaySubtitle = try container.decodeIfPresent(String.self, forKey: .displaySubtitle)
        coverPath = try container.decodeIfPresent(String.self, forKey: .coverPath)
        mediaUpdatedAt = try container.decodeISODateIfPresent(forKey: .mediaUpdatedAt)
        episode = try container.decodeIfPresent(PodcastEpisode.self, forKey: .episode)

        if
            episodeId?.isEmpty == false,
            let podcast = try container.decodeIfPresent(Podcast.self, forKey: .media) {
            media = .podcast(podcast)
        } else if let book = try container.decodeIfPresent(Book.self, forKey: .media) {
            media = .book(book)
        } else {
            media = nil
        }
    }

}

extension MediaProgress: Sendable {}
