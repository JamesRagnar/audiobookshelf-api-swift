//
//  Dictionary+Interface.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-20.
//

extension Dictionary where Key == String, Value == String {
    
    mutating func setIfPresent(_ key: String, _ value: String?) {
        if let value {
            self[key] = value
        }
    }

}
