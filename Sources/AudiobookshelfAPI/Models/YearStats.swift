//
//  YearStats.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation

/// Statistics for admin-level yearly overview.
///
/// Note: This matches the server's `getStatsForYear()` response structure
/// from `server/utils/queries/adminStats.js`.
public struct YearStats {

    /// Information about a top author, narrator, or genre.
    public struct TopItem: Decodable, Sendable {
        /// The name of the author or narrator, or the genre name.
        public let name: String?
        /// The genre (only present for top genres).
        public let genre: String?
        /// Total listening time in seconds for this item.
        public let time: Int
    }

    /// The number of listening sessions in the year.
    public let numListeningSessions: Int

    /// The number of books added in the year.
    public let numBooksAdded: Int

    /// The number of authors added in the year.
    public let numAuthorsAdded: Int

    /// The total size (in bytes) of books added in the year.
    public let totalBooksAddedSize: Int

    /// The total duration (in seconds) of books added in the year.
    public let totalBooksAddedDuration: Int

    /// Array of library item IDs for books added with covers (max 25).
    public let booksAddedWithCovers: [String]

    /// The total size (in bytes) of all books at the end of the year.
    public let totalBooksSize: Int

    /// The total duration (in seconds) of all books at the end of the year.
    public let totalBooksDuration: Int

    /// Total listening time (in seconds) for the year.
    public let totalListeningTime: Int

    /// Total number of books at the end of the year.
    public let numBooks: Int

    /// Top 3 authors by listening time.
    public let topAuthors: [TopItem]

    /// Top 3 narrators by listening time.
    public let topNarrators: [TopItem]

    /// Top 3 genres by listening time.
    public let topGenres: [TopItem]

}

extension YearStats: Decodable {}
extension YearStats: Sendable {}
