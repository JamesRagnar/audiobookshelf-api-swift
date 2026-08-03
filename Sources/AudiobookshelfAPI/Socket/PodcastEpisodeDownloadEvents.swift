//
//  PodcastEpisodeDownloadEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import RagnarSocketIO

/// A podcast episode has been queued for download.
public struct EpisodeDownloadQueuedEvent: SocketEvent {

    public static let name = "episode_download_queued"

    public typealias Schema = PodcastEpisodeDownload

}

/// A podcast episode has started downloading.
public struct EpisodeDownloadStartedEvent: SocketEvent {

    public static let name = "episode_download_started"

    public typealias Schema = PodcastEpisodeDownload

}

/// A podcast episode has finished downloading.
public struct EpisodeDownloadFinishedEvent: SocketEvent {

    public static let name = "episode_download_finished"

    public typealias Schema = PodcastEpisodeDownload

}

/// A podcast episode was added to a podcast.
public struct EpisodeAddedEvent: SocketEvent {

    public static let name = "episode_added"

    public typealias Schema = PodcastEpisode

}

/// The podcast episode download queue was cleared.
public struct EpisodeDownloadQueueClearedEvent: SocketEvent {

    public static let name = "episode_download_queue_cleared"

    public typealias Schema = String

}
