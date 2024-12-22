//
//  Podcast.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct Podcast {
    
    /// The ID of the library item that contains the podcast.
    /// - Note: Podcast Minified - Removed Attribute
    public let libraryItemId: String?
    
    /// The metadata for the podcast.
    /// - Note: Podcast Minified - metadata is Podcast Metadata Minified
    /// - Note: Podcast Expanded - metadata is Podcast Metadata Expanded
    public let metadata: PodcastMetadata
    
    /// The absolute path on the server of the cover file. Will be null if there is no cover.
    public let coverPath: String?
    
    /// The podcast's tags.
    public let tags: [String]
    
    /// The downloaded episodes of the podcast.
    /// - Note: Podcast Minified - Removed Attribute
    /// - Note: Podcast Expanded - episodes is Array of Podcast Episodes Expanded
    public let episodes: [PodcastEpisode]?
    
    /// Whether the server will automatically download podcast episodes according to the schedule.
    public let autoDownloadEpisodes: Bool
    
    /// The cron expression for when to automatically download podcast episodes.
    public let autoDownloadSchedule: String
    
    /// The time (in ms since POSIX epoch) when the podcast was checked for new episodes.
    public let lastEpisodeCheck: Int
    
    /// The maximum number of podcast episodes to keep when automatically downloading new episodes. Episodes beyond this limit will be deleted. If 0, all episodes will be kept.
    public let maxEpisodesToKeep: Int
    
    /// The maximum number of podcast episodes to download when automatically downloading new episodes. If 0, all episodes will be downloaded.
    public let maxNewEpisodesToDownload: Int
    
    // MARK: Podcast Minified
    
    /// The number of downloaded episodes for the podcast.
    /// - Note: Podcast Minified - Added Attribute
    public let numEpisodes: Int?
    
    // MARK: Podcast Minified + Expanded
    
    /// The total size (in bytes) of the podcast.
    /// - Note: Podcast Minified - Added Attribute
    /// - Note: Podcast Expanded - Added Attribute
    public let size: Int?
    
}

extension Podcast: Decodable {}
extension Podcast: Sendable {}
