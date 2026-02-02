//
//  RSSFeedEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import RagnarNetworking

/// An RSS feed was opened.
public struct RssFeedOpenEvent: SocketInboundEvent {
    
    public static let name = "rss_feed_open"
    
    public typealias Payload = RSSFeed

}

/// An RSS feed was closed.
public struct RssFeedClosedEvent: SocketInboundEvent {
    
    public static let name = "rss_feed_closed"
    
    public typealias Payload = RSSFeed

}
