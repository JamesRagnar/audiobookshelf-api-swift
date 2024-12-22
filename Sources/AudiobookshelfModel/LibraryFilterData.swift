//
//  LibraryFilterData.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct LibraryFilterData {
    
    /// The authors of books in the library.
    public let authors: [Author]
    
    /// The genres of books in the library.
    public let genres: [String]
    
    /// The tags in the library.
    public let tags: [String]
    
    /// The series in the library. The series will only have their id and name.
    public let series: [Series]
    
    /// The narrators of books in the library.
    public let narrators: [String]
    
    /// The languages of books in the library.
    public let languages: [String]
    
}

extension LibraryFilterData: Decodable {}
extension LibraryFilterData: Sendable {}
