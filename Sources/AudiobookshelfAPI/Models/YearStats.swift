import Foundation

/// User year statistics on 2.26.0...2.37.1. Arrays are required even when empty.
public struct YearStats: Decodable, Sendable {

    public struct TopAuthor: Decodable, Sendable {

        /// Required wire name: author name (2.26.0+).
        public let name: String

        /// Required wire time: rounded listening seconds (2.26.0+).
        public let time: Int

    }

    public struct TopGenre: Decodable, Sendable {

        /// Required wire genre: genre name (2.26.0+).
        public let genre: String

        /// Required wire time: rounded listening seconds (2.26.0+).
        public let time: Int

    }

    public struct MostListenedNarrator: Decodable, Sendable {

        /// Required wire name: narrator name (2.26.0+).
        public let name: String

        /// Required wire time: rounded listening seconds (2.26.0+).
        public let time: Int

    }

    public struct MostListenedMonth: Decodable, Sendable {

        /// Required wire month: zero-based month: 0 January through 11 December (2.26.0+).
        public let month: Int

        /// Required wire time: rounded listening seconds (2.26.0+).
        public let time: Int

    }

    public struct LongestAudiobook: Decodable, Sendable {

        /// Required wire id: book ID, not library-item ID (2.26.0+).
        public let id: String

        /// Required wire title: book title (2.26.0+).
        public let title: String

        /// Required wire duration: rounded duration seconds (2.26.0+).
        public let duration: Int

        /// Required wire finishedAt: ISO-8601 completion date (2.26.0+).
        public let finishedAt: Date

        private enum CodingKeys: CodingKey {
            case id, title, duration, finishedAt
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(String.self, forKey: .id)
            title = try container.decode(String.self, forKey: .title)
            duration = try container.decode(Int.self, forKey: .duration)
            finishedAt = try container.decodeISODate(forKey: .finishedAt)
        }

    }

    /// Required wire totalListeningSessions: session count (2.26.0+).
    public let totalListeningSessions: Int

    /// Required wire totalListeningTime: rounded listening seconds (2.26.0+).
    public let totalListeningTime: Int

    /// Required wire totalBookListeningTime: rounded book listening seconds (2.26.0+).
    public let totalBookListeningTime: Int

    /// Required wire totalPodcastListeningTime: rounded podcast listening seconds (2.26.0+).
    public let totalPodcastListeningTime: Int

    /// Required wire numBooksFinished: finished-book progress count (2.26.0+).
    public let numBooksFinished: Int

    /// Required wire numBooksListened: distinct listened book titles (2.26.0+).
    public let numBooksListened: Int

    /// Required wire topAuthors: [] when empty (2.26.0+).
    public let topAuthors: [TopAuthor]

    /// Required wire topGenres: [] when empty (2.26.0+).
    public let topGenres: [TopGenre]

    /// Nullable wire mostListenedNarrator: null when none (2.26.0+).
    public let mostListenedNarrator: MostListenedNarrator?

    /// Nullable wire mostListenedMonth: null when none (2.26.0+).
    public let mostListenedMonth: MostListenedMonth?

    /// Nullable wire longestAudiobookFinished: null when none (2.26.0+).
    public let longestAudiobookFinished: LongestAudiobook?

    /// Required wire booksWithCovers: library-item IDs selected for covers (2.26.0+).
    public let booksWithCovers: [String]

    /// Required wire finishedBooksWithCovers: finished library-item IDs selected for covers (2.26.0+).
    public let finishedBooksWithCovers: [String]

}
