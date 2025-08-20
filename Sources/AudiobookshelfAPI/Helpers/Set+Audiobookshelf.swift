//
//  Set+Audiobookshelf.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2025-08-19.
//

import Foundation

extension Set where Element: RawRepresentable, Element.RawValue == String {
    
    func joined(separator: String = ",") -> String? {
        guard !isEmpty else { return nil }
        return map { $0.rawValue }.joined(separator: ",")
    }
    
}
