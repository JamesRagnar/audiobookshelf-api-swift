//
//  RSSFeedEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import RagnarSocketIO

/// An RSS feed was opened.
/// On server 2.38.0+, delivered only to users with library access.
public struct RssFeedOpenEvent: SocketEvent {

    public static let name = "rss_feed_open"

    public typealias Schema = RSSFeed

}

/// An RSS feed was closed.
/// On server 2.38.0+, delivered only to users with library access.
/// The event may be omitted when the entity's library cannot be resolved.
public struct RssFeedClosedEvent: SocketEvent {

    public static let name = "rss_feed_closed"

    public typealias Schema = RSSFeed

}
