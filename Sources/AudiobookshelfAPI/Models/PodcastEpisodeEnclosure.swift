//
//  PodcastEpisodeEnclosure.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct PodcastEpisodeEnclosure {

    /// The URL where the podcast episode's audio file was downloaded from.
    ///
    /// The server only emits an enclosure object at all when this value is set, so it is always present.
    public let url: String

    /// The MIME type of the podcast episode's audio file.
    ///
    /// Null when the feed omitted it, or when the enclosure was set through `UpdatePodcastEpisode`
    /// without a type.
    public let type: String?

    /// The size (in bytes) that was reported when downloading the podcast episode's audio file.
    ///
    /// Sent as a string even though the server stores it as an integer. Null when the feed omitted it,
    /// or when the enclosure was set through `UpdatePodcastEpisode` without a length.
    public let length: String?

}

extension PodcastEpisodeEnclosure: Decodable {}
extension PodcastEpisodeEnclosure: Sendable {}
