//
//  PodcastEpisodeDownload.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct PodcastEpisodeDownload {
    
    /// The ID of the podcast episode download.
    public let id: String
    
    /// The display title of the episode to be downloaded.
    public let episodeDisplayTitle: String
    
    /// The URL from which to download the episode.
    public let url: String
    
    /// The ID of the library item the episode belongs to.
    public let libraryItemId: String
    
    /// The ID of the library the episode's podcast belongs to.
    public let libraryId: String
    
    /// Whether the episode has finished downloading.
    public let isFinished: Bool
    
    /// Whether the episode failed to download.
    public let failed: Bool
    
    /// The time (in ms since POSIX epoch) when the episode started downloading. Will be null if it has not started downloading yet.
    public let startedAt: Int?
    
    /// The time (in ms since POSIX epoch) when the podcast episode download request was created.
    public let createdAt: Int
    
    /// The time (in ms since POSIX epoch) when the episode finished downloading. Will be null if it has not finished.
    public let finishedAt: Int?
    
    /// The title of the episode's podcast.
    public let podcastTitle: String?
    
    /// Whether the episode's podcast is explicit.
    public let podcastExplicit: Bool
    
    /// The season of the podcast episode.
    public let season: String?
    
    /// The episode number of the podcast episode.
    public let episode: String?
    
    /// The type of the podcast episode.
    public let episodeType: String
    
    /// The time (in ms since POSIX epoch) when the episode was published.
    public let publishedAt: Int?
    
}

extension PodcastEpisodeDownload: Decodable {}
extension PodcastEpisodeDownload: Sendable {}

