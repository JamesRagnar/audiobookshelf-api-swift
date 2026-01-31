//
//  YearStats.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation

/// Yearly listening statistics for a user.
public struct YearStats {

    /// Top author statistics for a year.
    public struct TopAuthor {
        /// The author ID.
        public let id: String
        /// The author name.
        public let name: String
        /// Number of books listened from this author.
        public let count: Int
    }

    /// Top genre statistics for a year.
    public struct TopGenre {
        /// The genre name.
        public let genre: String
        /// Number of items in this genre.
        public let count: Int
    }

    /// Most listened narrator for a year.
    public struct MostListenedNarrator {
        /// The narrator name.
        public let name: String
        /// Listening time in milliseconds.
        public let time: Int
    }

    /// Most listened month for a year.
    public struct MostListenedMonth {
        /// The month (1-12).
        public let month: Int
        /// Listening time in milliseconds.
        public let time: Int
    }

    /// Longest audiobook finished in a year.
    public struct LongestAudiobook {
        /// The book ID.
        public let id: String
        /// The book title.
        public let title: String
        /// Duration in seconds.
        public let duration: Float
    }

    // MARK: - Counts

    /// Total number of unique items in user's library.
    public let totalItems: Int

    /// Total number of unique authors in user's library.
    public let totalAuthors: Int

    /// Total number of unique genres in user's library.
    public let totalGenres: Int

    /// Number of books listened to (started or continued).
    public let numListenedBooks: Int

    /// Number of books finished.
    public let numFinishedBooks: Int

    // MARK: - Durations

    /// Total duration of book content in user's library (seconds).
    public let totalBookDuration: Float

    /// Total duration of podcast content in user's library (seconds).
    public let totalPodcastDuration: Float

    /// Total time spent listening to books (milliseconds).
    public let totalBookListeningTime: Int

    /// Total time spent listening to podcasts (milliseconds).
    public let totalPodcastListeningTime: Int

    // MARK: - Top Lists

    /// Top authors by listening time.
    public let topAuthors: [TopAuthor]

    /// Top genres by listening time.
    public let topGenres: [TopGenre]

    // MARK: - Most Listened

    /// Most listened narrator (if any).
    public let mostListenedNarrator: MostListenedNarrator?

    /// Most listened month (if any).
    public let mostListenedMonth: MostListenedMonth?

    // MARK: - Records

    /// Longest audiobook finished this year (if any).
    public let longestAudiobookFinished: LongestAudiobook?

    /// Number of books with covers.
    public let booksWithCovers: Int

    /// Number of finished books with covers.
    public let finishedBooksWithCovers: Int

}

extension YearStats: Decodable {}
extension YearStats: Sendable {}

extension YearStats.TopAuthor: Decodable {}
extension YearStats.TopAuthor: Sendable {}

extension YearStats.TopGenre: Decodable {}
extension YearStats.TopGenre: Sendable {}

extension YearStats.MostListenedNarrator: Decodable {}
extension YearStats.MostListenedNarrator: Sendable {}

extension YearStats.MostListenedMonth: Decodable {}
extension YearStats.MostListenedMonth: Sendable {}

extension YearStats.LongestAudiobook: Decodable {}
extension YearStats.LongestAudiobook: Sendable {}
