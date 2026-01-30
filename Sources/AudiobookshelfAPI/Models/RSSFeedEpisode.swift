//
//  RSSFeedEpisode.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct RSSFeedEpisode {
    
    /// The ID of the RSS feed episode.
    public let id: String

    /// The title of the RSS feed episode.
    public let title: String?

    /// An HTML encoded description of the RSS feed episode.
    public let description: String?

    ///Download information for the RSS feed episode.
    public let enclosure: PodcastEpisodeEnclosure

    /// The RSS feed episode's publication date.
    public let pubDate: String?

    /// A URL to display to the RSS feed user.
    public let link: String?

    /// The author of the RSS feed episode.
    public let author: String?
    
    /// Whether the RSS feed episode is explicit.
    public let explicit: String?

    /// The duration (in seconds) of the RSS feed episode.
    public let duration: Float?

    /// The season of the RSS feed episode.
    public let season: String?

    /// The episode number of the RSS feed episode.
    public let episode: String?

    /// The type of the RSS feed episode.
    public let episodeType: String?

    /// The path on the server of the audio file the RSS feed episode is for.
    public let fullPath: String?
        
}

extension RSSFeedEpisode: Decodable {}
extension RSSFeedEpisode: Sendable {}
