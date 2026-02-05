//
//  Dictionary+Audiobookshelf.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2025-08-19.
//

import Foundation

extension Dictionary where Key == String, Value == String? {

    mutating func setIfPresent(_ key: String, _ value: String?) {
        guard let value else { return }

        self[key] = value
    }

}
