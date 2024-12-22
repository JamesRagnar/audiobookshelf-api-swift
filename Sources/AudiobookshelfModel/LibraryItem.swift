//
//  LibraryItem.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct LibraryItem {
    
    /// The ID of the library item.
    public let id: String
    
    /// The inode of the library item.
    public let ino: String
    
    /// The ID of the library the item belongs to.
    public let libraryId: String
    
    /// The ID of the folder the library item is in.
    public let folderId: String
    
    /// The path of the library item on the server.
    public let path: String
    
    /// The path, relative to the library folder, of the library item.
    public let relPath: String
    
    /// Whether the library item is a single file in the root of the library folder.
    public let isFile: Bool
    
    /// The time (in ms since POSIX epoch) when the library item was last modified on disk.
    public let mtimeMs: Int
    
    /// The time (in ms since POSIX epoch) when the library item status was changed on disk.
    public let ctimeMs: Int
    
    ///  The time (in ms since POSIX epoch) when the library item was created on disk. Will be 0 if unknown.
    public let birthtimeMs: Int
    
    /// The time (in ms since POSIX epoch) when the library item was added to the library.
    public let addedAt: Int
    
    /// The time (in ms since POSIX epoch) when the library item was last updated. (Read Only)
    public let updatedAt: Int
    
    /// The time (in ms since POSIX epoch) when the library item was last scanned. Will be null if the server has not yet scanned the library item.
    /// - Note: Library Item Minified - Removed Attribute
    public let lastScan: Int?
    
    /// The version of the scanner when last scanned. Will be null if it has not been scanned.
    /// - Note: Library Item Minified - Removed Attribute
    public let scanVersion: String?
    
    /// Whether the library item was scanned and no longer exists.
    public let isMissing: Bool
    
    /// Whether the library item was scanned and no longer has media files.
    public let isInvalid: Bool
    
    /// What kind of media the library item contains. Will be book or podcast.
    public let mediaType: MediaType
    
    /// The media of the library item.
    /// - Note: Library Item Minified - media is Book Minified or Podcast Minified
    /// - Note: Library Item Expanded - media is Book Expanded or Podcast Expanded
    public let media: Media
    
    /// The files of the library item.
    /// - Note: Library Item Minified - Removed Attribute
    public let libraryFiles: [LibraryFile]?
    
    // MARK: Library Item Minified
    
    /// The number of library files for the library item.
    /// - Note: Library Item Minified - Added Attribute
    public let numFiles: Int?
    
    // MARK: Library Item Minified + Expanded
    
    /// The total size (in bytes) of the library item.
    /// - Note: Library Item Minified - Added Attribute
    /// - Note: Library Item Expanded - Added Attribute
    public let size: Int?
    
    // MARK: Library Item Collapsed Series
    
    public let collapsedSeries: Series?
    
    // MARK: Library Item Expanded
    
    /// If progress was requested, the user's progress for the book or podcast episode. If no progress exists, neither will this attribute.
    public let userMediaProgress: MediaProgress?
    
    /// If rssfeed was requested, the open RSS feed of the library item. Will be null if the RSS feed for this library item is closed.
    public let rssFeed: RSSFeed?
    
    /// If downloads was requested, the podcast episodes currently in the download queue.
    public let episodesDownloading: [PodcastEpisodeDownload]?
    
    // MARK: Library Item Personalized
    
    /// If the library item is for a podcast, the media progress's corresponding podcast episode.
    /// Will not exist for book library items.
    /// - Note: Library Item Personalized - Added Attribute
    public let recentEpisode: PodcastEpisode?
    
    /// The time (in ms since POSIX epoch) of the most recent progress update of any book in the series.
    /// - Note: Library Item Personalized - Added Attribute
    public let prevBookInProgressLastUpdate: Int?
    
    /// The recommendation weight of the library item.
    /// - Note: Library Item Personalized - Added Attribute
    public let weight: Float?

    /// The time (in ms since POSIX epoch) when the book or episode was finished.
    /// - Note: Library Item Personalized - Added Attribute
    public let finishedAt: Int?

}

public extension LibraryItem {
    
    enum MediaType: String, Decodable, Sendable {
        case book
        case podcast
    }
    
    enum Media: Sendable {
        case book(Book)
        case podcast(Podcast)
    }
    
}

extension LibraryItem: Decodable {
    
    enum CodingKeys: CodingKey {
        case id
        case ino
        case libraryId
        case folderId
        case path
        case relPath
        case isFile
        case mtimeMs
        case ctimeMs
        case birthtimeMs
        case addedAt
        case updatedAt
        case lastScan
        case scanVersion
        case isMissing
        case isInvalid
        case mediaType
        case media
        case libraryFiles
        case numFiles
        case size
        case collapsedSeries
        case userMediaProgress
        case rssFeed
        case episodesDownloading
        case recentEpisode
        case prevBookInProgressLastUpdate
        case weight
        case finishedAt
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.ino = try container.decode(String.self, forKey: .ino)
        self.libraryId = try container.decode(String.self, forKey: .libraryId)
        self.folderId = try container.decode(String.self, forKey: .folderId)
        self.path = try container.decode(String.self, forKey: .path)
        self.relPath = try container.decode(String.self, forKey: .relPath)
        self.isFile = try container.decode(Bool.self, forKey: .isFile)
        self.mtimeMs = try container.decode(Int.self, forKey: .mtimeMs)
        self.ctimeMs = try container.decode(Int.self, forKey: .ctimeMs)
        self.birthtimeMs = try container.decode(Int.self, forKey: .birthtimeMs)
        self.addedAt = try container.decode(Int.self, forKey: .addedAt)
        self.updatedAt = try container.decode(Int.self, forKey: .updatedAt)
        self.lastScan = try container.decodeIfPresent(Int.self, forKey: .lastScan)
        self.scanVersion = try container.decodeIfPresent(String.self, forKey: .scanVersion)
        self.isMissing = try container.decode(Bool.self, forKey: .isMissing)
        self.isInvalid = try container.decode(Bool.self, forKey: .isInvalid)
        self.mediaType = try container.decode(MediaType.self, forKey: .mediaType)
        self.libraryFiles = try container.decodeIfPresent([LibraryFile].self, forKey: .libraryFiles)
        self.numFiles = try container.decodeIfPresent(Int.self, forKey: .numFiles)
        self.size = try container.decodeIfPresent(Int.self, forKey: .size)
        self.collapsedSeries = try container.decodeIfPresent(Series.self, forKey: .collapsedSeries)
        self.userMediaProgress = try container.decodeIfPresent(MediaProgress.self, forKey: .userMediaProgress)
        self.rssFeed = try container.decodeIfPresent(RSSFeed.self, forKey: .rssFeed)
        self.episodesDownloading = try container.decodeIfPresent([PodcastEpisodeDownload].self, forKey: .episodesDownloading)
        self.recentEpisode = try container.decodeIfPresent(PodcastEpisode.self, forKey: .recentEpisode)
        self.prevBookInProgressLastUpdate = try container.decodeIfPresent(Int.self, forKey: .prevBookInProgressLastUpdate)
        self.weight = try container.decodeIfPresent(Float.self, forKey: .weight)
        self.finishedAt = try container.decodeIfPresent(Int.self, forKey: .finishedAt)
        
        switch mediaType {
        case .book:
            self.media = .book(try container.decode(Book.self, forKey: .media))
        case .podcast:
            self.media = .podcast(try container.decode(Podcast.self, forKey: .media))
        }
    }

}

extension LibraryItem: Sendable {}
