//
//  PodcastMetadata.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct PodcastMetadata {
    
    /// The title of the podcast. Will be null if unknown.
    public let title: String?
    
    /// The author of the podcast. Will be null if unknown.
    public let author: String?
    
    /// The description for the podcast. Will be null if unknown.
    public let description: String?
    
    /// The release date of the podcast. Will be null if unknown.
    public let releaseDate: String?
    
    /// The podcast's genres.
    public let genres: [String]
    
    /// A URL of an RSS feed for the podcast. Will be null if unknown.
    public let feedUrl: String?
    
    /// A URL of a cover image for the podcast. Will be null if unknown.
    public let imageUrl: String?
    
    /// A URL of an iTunes page for the podcast. Will be null if unknown.
    public let itunesPageUrl: String?
    
    /// The iTunes ID for the podcast. Will be null if unknown.
    public let itunesId: String?
    
    /// The iTunes Artist ID for the author of the podcast. Will be null if unknown.
    public let itunesArtistId: String?
    
    /// Whether the podcast has been marked as explicit.
    public let explicit: Bool
    
    /// The language of the podcast. Will be null if unknown.
    public let language: String?
    
    /// The type of the podcast.
    public let type: String?
    
    // MARK: Podcast Metadata Minified + Expanded
    
    /// The title of the podcast with any prefix moved to the end.
    /// - Note: Podcast Metadata Minified - Added Attribute
    /// - Note: Podcast Metadata Expanded - Added Attribute
    public let titleIgnorePrefix: String?
    
}

extension PodcastMetadata: Decodable {}
extension PodcastMetadata: Sendable {}
