//
//  MediaProgress.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-17.
//

public struct MediaProgress {
    
    /// The ID of the media progress. If the media progress is for a book, this will just be the libraryItemId. If for a podcast episode, it will be a hyphenated combination of the libraryItemId and episodeId.
    public let id: String
    
    /// The ID of the library item the media progress is of.
    public let libraryItemId: String
    
    /// The ID of the podcast episode the media progress is of. Will be null if the progress is for a book.
    public let episodeId: String?
    
    /// The total duration (in seconds) of the media. Will be 0 if the media was marked as finished without the user listening to it.
    public let duration: Float
    
    /// The percentage completion progress of the media. Will be 1 if the media is finished.
    public let progress: Float
    
    /// The current time (in seconds) of the user's progress. If the media has been marked as finished, this will be the time the user was at beforehand.
    public let currentTime: Float
    
    /// Whether the media is finished.
    public let isFinished: Bool
    
    /// Whether the media will be hidden from the "Continue Listening" shelf.
    public let hideFromContinueListening: Bool
    
    /// The time (in ms since POSIX epoch) when the media progress was last updated.
    public let lastUpdate: Int
    
    /// The time (in ms since POSIX epoch) when the media progress was created.
    public let startedAt: Int
    
    /// The time (in ms since POSIX epoch) when the media was finished. Will be null if the media has is not finished.
    public let finishedAt: Int?
    
    // MARK: Media Progress With Media
    
    /// The media of the library item the media progress is for.
    /// - Note: Media Progress with Media - Added Attribute
    public let media: Media?
    
    /// The podcast episode the media progress is for. Will only exist if the media progress is for a podcast episode.
    /// - Note: Media Progress with Media - Added Attribute
    public let episode: PodcastEpisode?
    
}

extension MediaProgress {
    
    public enum Media: Sendable {
        case book(Book)
        case podcast(Podcast)
    }
}

extension MediaProgress: Decodable {
    
    enum CodingKeys: CodingKey {
        case id
        case libraryItemId
        case episodeId
        case duration
        case progress
        case currentTime
        case isFinished
        case hideFromContinueListening
        case lastUpdate
        case startedAt
        case finishedAt
        case media
        case episode
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        libraryItemId = try container.decode(String.self, forKey: .libraryItemId)
        episodeId = try container.decodeIfPresent(String.self, forKey: .episodeId)
        duration = try container.decode(Float.self, forKey: .duration)
        progress = try container.decode(Float.self, forKey: .progress)
        currentTime = try container.decode(Float.self, forKey: .currentTime)
        isFinished = try container.decode(Bool.self, forKey: .isFinished)
        hideFromContinueListening = try container.decode(Bool.self, forKey: .hideFromContinueListening)
        lastUpdate = try container.decode(Int.self, forKey: .lastUpdate)
        startedAt = try container.decode(Int.self, forKey: .startedAt)
        finishedAt = try container.decodeIfPresent(Int.self, forKey: .finishedAt)
        episode = try container.decodeIfPresent(PodcastEpisode.self, forKey: .episode)
        
        if
            episodeId?.isEmpty == false,
            let podcast = try container.decodeIfPresent(Podcast.self, forKey: .media)
        {
            media = .podcast(podcast)
        } else if let book = try container.decodeIfPresent(Book.self, forKey: .media) {
            media = .book(book)
        } else {
            media = nil
        }
    }
    
}

extension MediaProgress: Sendable {}
