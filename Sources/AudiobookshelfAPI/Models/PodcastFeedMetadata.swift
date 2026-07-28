//
//  PodcastFeedMetadata.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

/// Metadata parsed out of a podcast's RSS feed.
///
/// Every field except ``categories`` is optional. The server builds this by reading channel elements
/// that a feed is free to omit, and emits null (or drops the key entirely) when an element is absent,
/// so nothing here can be relied on to be present.
public struct PodcastFeedMetadata {

    /// A URL for the podcast's cover image.
    public let image: String?

    /// The podcast's categories. Can be similar to genres. Empty rather than null when there are none.
    public let categories: [String]

    /// A URL of an RSS feed for the podcast.
    public let feedUrl: String?

    /// A HTML encoded description of the podcast.
    public let description: String?

    /// A plain text description of the podcast.
    public let descriptionPlain: String?

    /// The podcast's title.
    public let title: String?

    /// The podcast's language.
    public let language: String?

    /// Whether the podcast is explicit. Will probably be "true" or "false".
    public let explicit: String?

    /// The podcast's author.
    public let author: String?

    /// The podcast's publication date.
    public let pubDate: String?

    /// A URL the RSS feed provided for possible display to the user.
    public let link: String?

    /// The iTunes podcast type, for example "episodic" or "serial".
    public let type: String?

}

extension PodcastFeedMetadata: Decodable {}
extension PodcastFeedMetadata: Sendable {}
