//
//  LibrarySettings.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct LibrarySettings {
    
    /// Whether the library should use square book covers. Must be 0 (for false) or 1 (for true).
    public let coverAspectRatio: Int
    
    /// Whether to disable the folder watcher for the library.
    public let disableWatcher: Bool
    
    /// Whether to skip matching books that already have an ASIN.
    public let skipMatchingMediaWithAsin: Bool

    /// Whether to skip matching books that already have an ISBN.
    public let skipMatchingMediaWithIsbn: Bool

    /// The cron expression for when to automatically scan the library folders. If null, automatic scanning will be disabled.
    public let autoScanCronExpression: String?

    /// Whether the library should only show audiobooks (hide ebook-only items).
    public let audiobooksOnly: Bool

    /// Whether EPUBs are allowed to run scripted content.
    public let epubsAllowScriptedContent: Bool?

    /// Whether to hide series with only one book.
    public let hideSingleBookSeries: Bool

    /// Whether to only show later books in the "Continue Series" shelf.
    public let onlyShowLaterBooksInContinueSeries: Bool

    /// The order of precedence for metadata sources.
    public let metadataPrecedence: [String]?

    /// The region to use when searching for podcasts.
    public let podcastSearchRegion: String?

    /// The percentage of completion at which to mark media as finished.
    public let markAsFinishedPercentComplete: Int?

    /// The time remaining (in seconds) at which to mark media as finished.
    public let markAsFinishedTimeRemaining: Int?

}

extension LibrarySettings: Decodable {}
extension LibrarySettings: Sendable {}
