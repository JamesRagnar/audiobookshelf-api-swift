//
//  PodcastFeed.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct PodcastFeed {
    
    /// The podcast's metadata from the feed.
    public let metadata: PodcastFeedMetadata
    
    /// The podcast's episodes from the feed.
    /// - Note: Podcast Feed Minified - Removed Attribute
    public let episodes: [PodcastFeedEpisode]?
    
    // MARK: Podcast Feed Minified
    
    /// The number of episodes the podcast has.
    /// - Note: Podcast Feed Minified - Added Attribute
    public let numEpisodes: Int?
    
}

extension PodcastFeed: Decodable {}
extension PodcastFeed: Sendable {}
