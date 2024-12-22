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
    public let skipMatchingMediaWithAsin: Bool?
    
    /// Whether to skip matching books that already have an ISBN.
    public let skipMatchingMediaWithIsbn: Bool?
    
    /// The cron expression for when to automatically scan the library folders. If null, automatic scanning will be disabled.
    public let autoScanCronExpression: String?
    
}

extension LibrarySettings: Decodable {}
extension LibrarySettings: Sendable {}
