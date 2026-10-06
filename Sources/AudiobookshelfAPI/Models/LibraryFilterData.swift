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

    /// Required publisher list, wire publishers (2.26.0+); [] for unrelated library types.
    public let publishers: [String]
    /// Required decade list, wire publishedDecades (2.26.0+).
    public let publishedDecades: [String]
    /// Required wire bookCount; not inferred from list lengths.
    public let bookCount: Int
    /// Required wire authorCount; not inferred from list lengths.
    public let authorCount: Int
    /// Required wire seriesCount; not inferred from list lengths.
    public let seriesCount: Int
    /// Required wire podcastCount; zero for book libraries.
    public let podcastCount: Int
    /// Required wire numIssues; issue count, zero when none.
    public let numIssues: Int
    /// Required wire loadedAt, epoch milliseconds when loaded.
    public let loadedAt: Int

}

extension LibraryFilterData: Decodable {}
extension LibraryFilterData: Sendable {}
