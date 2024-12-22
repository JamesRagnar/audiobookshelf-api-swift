//
//  PodcastEpisodeEnclosure.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct PodcastEpisodeEnclosure {
    
    /// The URL where the podcast episode's audio file was downloaded from.
    public let url: String
    
    /// The MIME type of the podcast episode's audio file.
    public let type: String
    
    /// The size (in bytes) that was reported when downloading the podcast episode's audio file.
    public let length: String
    
}

extension PodcastEpisodeEnclosure: Decodable {}
extension PodcastEpisodeEnclosure: Sendable {}

