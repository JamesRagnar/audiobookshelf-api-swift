//
//  PodcastFeedEpisode.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

/// Canonical parsed RSS episode on 2.26.0+.
/// Required string fields are normalized to empty strings when original XML metadata is absent.
/// Optional values decode missing/null as nil; enclosure and chapters remain required.
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

    /// Optional wire publishedAt in epoch milliseconds; null for missing/invalid pubDate (2.26.0+).
    public let publishedAt: Int?

    /// Optional parsed fractional seconds (wire durationSeconds), 2.26.0+;
    /// missing/null for absent, invalid or zero duration.
    public let durationSeconds: Double?

    /// Optional RSS identifier, wire guid; missing/null means unavailable.
    public let guid: String?
    /// Optional external chapter URL, wire chaptersUrl; missing/null means unavailable.
    public let chaptersUrl: String?
    /// Optional external chapter MIME type, wire chaptersType.
    public let chaptersType: String?
    /// Required parsed chapters (wire chapters), 2.26.0+; [] when none.
    public let chapters: [BookChapter]

    /// Download information for the podcast episode.
    public let enclosure: PodcastEpisodeEnclosure

}

extension PodcastFeedEpisode: Decodable {}
extension PodcastFeedEpisode: Sendable {}
