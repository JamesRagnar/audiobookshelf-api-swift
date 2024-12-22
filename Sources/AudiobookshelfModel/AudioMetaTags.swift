//
//  AudioMetaTags.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

/// ID3 metadata tags pulled from the audio file on import. Only non-null tags will be returned in requests.
///
/// https://en.wikipedia.org/wiki/ID3
public typealias AudioMetaTags = [String: String?]

extension AudioMetaTags: Sendable {}
