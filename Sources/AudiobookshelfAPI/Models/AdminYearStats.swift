import Foundation

/// Administrator year statistics on 2.26.0...2.37.1.
/// Totals include all books added through the selected year, not just user-accessible items.
public struct AdminYearStats: Decodable, Sendable {

    public struct NamedListeningTime: Decodable, Sendable {
        /// Required wire name.
        public let name: String
        /// Required wire time, rounded listening seconds.
        public let time: Int
    }

    public struct GenreListeningTime: Decodable, Sendable {
        /// Required wire genre.
        public let genre: String
        /// Required wire time, rounded listening seconds.
        public let time: Int
    }

    /// Required wire numListeningSessions: session count (2.26.0+).
    public let numListeningSessions: Int

    /// Required wire numBooksAdded: books added during the year (2.26.0+).
    public let numBooksAdded: Int

    /// Required wire numAuthorsAdded: authors added during the year (2.26.0+).
    public let numAuthorsAdded: Int

    /// Required wire numBooks: all books added through the year (2.26.0+).
    public let numBooks: Int

    /// Required wire totalBooksAddedSize: bytes added during the year (2.26.0+).
    public let totalBooksAddedSize: Int

    /// Required wire totalBooksSize: bytes through the year (2.26.0+).
    public let totalBooksSize: Int

    /// Required wire totalBooksAddedDuration: rounded seconds added during the year (2.26.0+).
    public let totalBooksAddedDuration: Int

    /// Required wire totalBooksDuration: unrounded seconds through the year (2.26.0+).
    public let totalBooksDuration: Double

    /// Required wire totalListeningTime: unrounded listening seconds (2.26.0+).
    public let totalListeningTime: Double

    /// Required wire booksAddedWithCovers: library-item IDs (2.26.0+).
    public let booksAddedWithCovers: [String]

    /// Required wire topAuthors: author times; [] when empty (2.26.0+).
    public let topAuthors: [NamedListeningTime]

    /// Required wire topNarrators: narrator times; [] when empty (2.26.0+).
    public let topNarrators: [NamedListeningTime]

    /// Required wire topGenres: genre times; [] when empty (2.26.0+).
    public let topGenres: [GenreListeningTime]

}
