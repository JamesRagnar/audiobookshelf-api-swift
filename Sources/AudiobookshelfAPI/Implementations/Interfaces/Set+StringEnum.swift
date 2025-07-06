//
//  File.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-21.
//

import Foundation

extension Set where Element: RawRepresentable, Element.RawValue == String {
    
    func joined(separator: String = ",") -> String? {
        guard !isEmpty else { return nil }
        return map { $0.rawValue }.joined(separator: ",")
    }
    
}
