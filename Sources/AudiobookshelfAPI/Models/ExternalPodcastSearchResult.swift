//
//  ExternalPodcastSearchResult.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation

public struct ExternalPodcastSearchResult {

    /// The title of the podcast.
    public let title: String

    /// The author/creator of the podcast.
    public let author: String?

    /// A description of the podcast.
    public let description: String?

    /// The RSS feed URL of the podcast.
    public let feedUrl: String?

    /// The iTunes ID of the podcast.
    public let itunesId: String?

    /// The iTunes page URL of the podcast.
    public let itunesPageUrl: String?

    /// The artwork/cover image URL.
    public let artwork: String?

    /// The genres of the podcast.
    public let genres: [String]?

}

extension ExternalPodcastSearchResult: Decodable {}
extension ExternalPodcastSearchResult: Sendable {}
