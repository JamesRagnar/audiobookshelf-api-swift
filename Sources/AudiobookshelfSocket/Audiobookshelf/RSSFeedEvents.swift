//
//  RSSFeedEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import AudiobookshelfModel

/// An RSS feed was opened.
public struct RssFeedOpenEvent: SocketEvent {
    
    public static let name = "rss_feed_open"
    
    public typealias Schema = RSSFeed

}

/// An RSS feed was closed.
public struct RssFeedClosedEvent: SocketEvent {
    
    public static let name = "rss_feed_closed"
    
    public typealias Schema = RSSFeed

}
