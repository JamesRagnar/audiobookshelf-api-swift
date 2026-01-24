//
//  YearStats.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation

public struct YearStats {

    /// The year for these statistics.
    public let year: Int

    /// Total listening time in seconds.
    public let totalTime: Double

    /// Total number of days listened.
    public let totalDays: Int

    /// Number of book items listened to.
    public let numListenedBooks: Int?

    /// Number of podcast episodes listened to.
    public let numListenedEpisodes: Int?

    /// Total number of finished items.
    public let numFinishedBooks: Int?

    /// Total number of finished podcast episodes.
    public let numFinishedEpisodes: Int?

    /// Most listened to genre.
    public let mostListenedGenre: String?

    /// Most listened to author.
    public let mostListenedAuthor: String?

    /// Total number of sessions.
    public let totalSessions: Int?

}

extension YearStats: Decodable {}
extension YearStats: Sendable {}
