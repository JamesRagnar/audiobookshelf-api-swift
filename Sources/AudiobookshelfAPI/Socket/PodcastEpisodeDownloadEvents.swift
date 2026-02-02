//
//  PodcastEpisodeDownloadEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import RagnarNetworking

/// A podcast episode has been queued for download.
public struct EpisodeDownloadQueuedEvent: SocketInboundEvent {
    
    public static let name = "episode_download_queued"
    
    public typealias Payload = PodcastEpisodeDownload

}

/// The podcast episode download queue has updated.
public struct EpisodeDownloadQueueUpdatedEvent: SocketInboundEvent {
    
    public static let name = "episode_download_queue_updated"
    
    public typealias Payload = Body

}

extension EpisodeDownloadQueueUpdatedEvent {
    
    public struct Body: Decodable, Sendable {
        
        /// The podcast episode currently being downloaded. Will only exist if an episode download is in progress.
        public let currentDownload: PodcastEpisodeDownload?
        
        /// The podcast episodes in the queue to be downloaded.
        public let queue: [PodcastEpisodeDownload]

    }

}

/// A podcast episode has started downloading.
public struct EpisodeDownloadStartedEvent: SocketInboundEvent {
    
    public static let name = "episode_download_started"
    
    public typealias Payload = PodcastEpisodeDownload

}

/// A podcast episode has finished downloading.
public struct EpisodeDownloadFinishedEvent: SocketInboundEvent {

    public static let name = "episode_download_finished"

    public typealias Payload = PodcastEpisodeDownload

}

/// A podcast episode was added to a podcast.
public struct EpisodeAddedEvent: SocketInboundEvent {

    public static let name = "episode_added"

    public typealias Payload = PodcastEpisode

}

/// The podcast episode download queue was cleared.
public struct EpisodeDownloadQueueClearedEvent: SocketInboundEvent {

    public static let name = "episode_download_queue_cleared"

    public typealias Payload = String

}
