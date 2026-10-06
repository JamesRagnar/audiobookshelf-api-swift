//
//  PlaybackSession.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct PlaybackSession {

    /// The ID of the playback session.
    public let id: String

    /// Optional wire userId, 2.26.0+; null for anonymous or deleted-user sessions.
    public let userId: String?

    /// The ID of the library that contains the library item.
    public let libraryId: String?

    /// The ID of the library item.
    public let libraryItemId: String?

    /// The ID of the podcast episode. Will be null if this playback session was started without an episode ID.
    public let episodeId: String?

    /// The ID of the book. Will be null if this playback session is for a podcast episode.
    public let bookId: String?

    /// The media type of the library item.
    public let mediaType: MediaType

    /// Required wire mediaMetadata, decoded using mediaType on 2.26.0+.
    public let mediaMetadata: MediaMetadata

    /// If the library item is a book, the chapters it contains.
    public let chapters: [BookChapter]?

    /// The title of the playing item to show to the user.
    public let displayTitle: String

    /// The author of the playing item to show to the user.
    public let displayAuthor: String

    /// The cover path of the library item's media.
    public let coverPath: String?

    /// Optional share-only wire coverAspectRatio (2.33.2+): 0 rectangular, 1 square.
    /// Ordinary sessions and older responses omit it; missing/null decodes as nil.
    public let coverAspectRatio: Int?

    /// The total duration (in seconds) of the playing item.
    public let duration: Float

    /// What play method the playback session is using.
    public let playMethod: PlayMethod

    /// The given media player when the playback session was requested.
    public let mediaPlayer: String?

    /// The given device info when the playback session was requested.
    public let deviceInfo: DeviceInfo?

    /// The server version the playback session was started with.
    public let serverVersion: String

    /// The day (in the format YYYY-MM-DD) the playback session was started.
    public let date: String

    /// The day of the week the playback session was started.
    public let dayOfWeek: String

    /// The amount of time (in seconds) the user has spent listening using this playback session.
    public let timeListening: Float?

    /// The time (in seconds) where the playback session started.
    public let startTime: Float

    /// The current time (in seconds) of the playback position.
    public let currentTime: Float

    /// The time (in ms since POSIX epoch) when the playback session was started.
    public let startedAt: Int

    /// The time (in ms since POSIX epoch) when the playback session was last updated.
    public let updatedAt: Int

    // MARK: Playback Session Expanded

    /// The audio tracks that are being played with the playback session.
    /// - Note: Playback Session Expanded - Added Attribute
    public let audioTracks: [AudioTrack]?

    /// The video track that is being played with the playback session. Will be null if the playback session is for a
    /// book or podcast.
    /// - Note: Playback Session Expanded - Added Attribute
    public let videoTrack: VideoTrack?

    /// The library item of the playback session.
    /// - Note: Playback Session Expanded - Added Attribute
    public let libraryItem: LibraryItem?

}

extension PlaybackSession: Decodable {

    private enum CodingKeys: CodingKey {
        case id
        case userId
        case libraryId
        case libraryItemId
        case episodeId
        case bookId
        case mediaType
        case mediaMetadata
        case chapters
        case displayTitle
        case displayAuthor
        case coverPath
        case coverAspectRatio
        case duration
        case playMethod
        case mediaPlayer
        case deviceInfo
        case serverVersion
        case date
        case dayOfWeek
        case timeListening
        case startTime
        case currentTime
        case startedAt
        case updatedAt
        case audioTracks
        case videoTrack
        case libraryItem
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        userId = try container.decodeIfPresent(String.self, forKey: .userId)
        libraryId = try container.decodeIfPresent(String.self, forKey: .libraryId)
        libraryItemId = try container.decodeIfPresent(String.self, forKey: .libraryItemId)
        episodeId = try container.decodeIfPresent(String.self, forKey: .episodeId)
        bookId = try container.decodeIfPresent(String.self, forKey: .bookId)
        mediaType = try container.decode(MediaType.self, forKey: .mediaType)
        mediaMetadata = try MediaMetadata(from: decoder)
        chapters = try container.decodeIfPresent([BookChapter].self, forKey: .chapters)
        displayTitle = try container.decode(String.self, forKey: .displayTitle)
        displayAuthor = try container.decode(String.self, forKey: .displayAuthor)
        coverPath = try container.decodeIfPresent(String.self, forKey: .coverPath)
        coverAspectRatio = try container.decodeIfPresent(Int.self, forKey: .coverAspectRatio)
        duration = try container.decode(Float.self, forKey: .duration)
        playMethod = try container.decode(PlayMethod.self, forKey: .playMethod)
        mediaPlayer = try container.decodeIfPresent(String.self, forKey: .mediaPlayer)
        deviceInfo = try container.decodeIfPresent(DeviceInfo.self, forKey: .deviceInfo)
        serverVersion = try container.decode(String.self, forKey: .serverVersion)
        date = try container.decode(String.self, forKey: .date)
        dayOfWeek = try container.decode(String.self, forKey: .dayOfWeek)
        timeListening = try container.decodeIfPresent(Float.self, forKey: .timeListening)
        startTime = try container.decode(Float.self, forKey: .startTime)
        currentTime = try container.decode(Float.self, forKey: .currentTime)
        startedAt = try container.decode(Int.self, forKey: .startedAt)
        updatedAt = try container.decode(Int.self, forKey: .updatedAt)
        audioTracks = try container.decodeIfPresent([AudioTrack].self, forKey: .audioTracks)
        videoTrack = try container.decodeIfPresent(VideoTrack.self, forKey: .videoTrack)
        libraryItem = try container.decodeIfPresent(LibraryItem.self, forKey: .libraryItem)
    }

}
extension PlaybackSession: Sendable {}

extension PlaybackSession {

    /// Required metadata object selected by the containing session's mediaType.
    /// Standalone decoding uses the containing session object and its discriminator.
    public enum MediaMetadata: Decodable, Sendable {
        case book(BookMetadata)
        case podcast(PodcastMetadata)

        private enum CodingKeys: CodingKey {
            case mediaType, mediaMetadata
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            switch try container.decode(MediaType.self, forKey: .mediaType) {
            case .book:
                self = .book(try container.decode(BookMetadata.self, forKey: .mediaMetadata))

            case .podcast:
                self = .podcast(try container.decode(PodcastMetadata.self, forKey: .mediaMetadata))
            }
        }
    }

    public enum MediaType: String {

        case book

        case podcast

    }

    public enum PlayMethod: Int {

        case directPlay = 0

        case directStream = 1

        case transcode = 2

        case local = 3

    }

    /// Placeholder for future video playback support.
    /// The audiobookshelf server does not currently support video media types.
    /// This struct is intentionally empty and will always be null in API responses.
    public struct VideoTrack {}

}

extension PlaybackSession.MediaType: Decodable {}
extension PlaybackSession.MediaType: Sendable {}

extension PlaybackSession.PlayMethod: Decodable {}
extension PlaybackSession.PlayMethod: Sendable {}

extension PlaybackSession.VideoTrack: Decodable {}
extension PlaybackSession.VideoTrack: Sendable {}
