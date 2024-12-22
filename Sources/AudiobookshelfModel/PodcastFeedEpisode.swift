//
//  PodcastFeedEpisode.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct PodcastFeedEpisode {
    
    /// The podcast episode's title.
    public let title: String
    
    /// The podcast episode's subtitle.
    public let subtitle: String
    
    /// A HTML encoded description of the podcast episode.
    public let description: String
    
    /// A plain text description of the podcast episode.
    public let descriptionPlain: String
    
    /// The podcast episode's publication date.
    public let pubDate: String
    
    /// The type of episode that the podcast episode is.
    public let episodeType: String
    /// The season of the podcast episode.
    public let season: String
    
    /// The episode of the season of the podcast.
    public let episode: String
    
    /// The author of the podcast episode.
    public let author: String
    
    /// The duration of the podcast episode as reported by the RSS feed.
    public let duration: String
    
    /// Whether the podcast episode is explicit.
    public let explicit: String
    
    /// The time (in ms since POSIX epoch) when the podcast episode was published.
    public let publishedAt: Int
    
    /// Download information for the podcast episode.
    public let enclosure: PodcastEpisodeEnclosure
    
}

extension PodcastFeedEpisode: Decodable {}
extension PodcastFeedEpisode: Sendable {}
