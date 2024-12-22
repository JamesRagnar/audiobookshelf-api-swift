//
//  StreamProgress.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct StreamProgress {
    
    /// The ID of the stream the progress is for.
    public let stream: String
    
    /// A human-readable percentage of transcode completion.
    public let percent: String
    
    /// The segment ranges that have been transcoded.
    public let chunks: [String]
    
    /// The total number of segments of the stream.
    public let numSegments: Int
        
}

extension StreamProgress: Decodable {}
extension StreamProgress: Sendable {}
