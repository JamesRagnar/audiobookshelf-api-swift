//
//  PodcastEpisode.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct PodcastEpisode {
    
    /// The ID of the library item that contains the podcast.
    public let libraryItemId: String
    
    /// The ID of the podcast episode.
    public let id: String
    
    /// The index of the podcast episode.
    public let index: Int?
    
    /// The season of the podcast episode, if known.
    public let season: String
    
    /// The episode of the season of the podcast, if known.
    public let episode: String
    
    /// The type of episode that the podcast episode is.
    public let episodeType: String
    
    /// The title of the podcast episode.
    public let title: String
    
    /// The subtitle of the podcast episode.
    public let subtitle: String
    
    /// A HTML encoded, description of the podcast episode.
    public let description: String
    
    /// Information about the podcast episode from when it was downloaded.
    public let enclosure: PodcastEpisodeEnclosure
    
    /// When the podcast episode was published.
    public let pubDate: String
    
    /// The audio file for the podcast episode.
    public let audioFile: AudioFile
    
    /// The time (in ms since POSIX epoch) when the podcast episode was published.
    public let publishedAt: Int
    
    /// The time (in ms since POSIX epoch) when the podcast episode was added to the library.
    public let addedAt: Int
    
    /// The time (in ms since POSIX epoch) when the podcast episode was last updated.
    public let updatedAt: Int
    
    // MARK: Podcast Episode Expanded

    /// The podcast episode's audio tracks from the audio file.
    /// - Note: Podcast Episode Expanded - Added Attribute
    public let audioTrack: AudioTrack?
    
    /// The total length (in seconds) of the podcast episode.
    /// - Note: Podcast Episode Expanded - Added Attribute
    public let duration: Float?
    
    /// The total size (in bytes) of the podcast episode.
    /// - Note: Podcast Episode Expanded - Added Attribute
    public let size: Int?
    
}

extension PodcastEpisode: Decodable {}
extension PodcastEpisode: Sendable {}
