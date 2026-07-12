//
//  Array+Audiobookshelf.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2025-08-19.
//

import Foundation

extension Array where Element == URLQueryItem {

    mutating func appendIfPresent(_ name: String, _ value: String?) {
        guard let value else { return }

        append(URLQueryItem(name: name, value: value))
    }

}
