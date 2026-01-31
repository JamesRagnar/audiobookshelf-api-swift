//
//  FilterData.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-31.
//

import Foundation

/// Filter data for a library, containing aggregated metadata for filtering and browsing.
/// Returned when requesting a library with the `?include=filterdata` query parameter.
public struct FilterData {

    /// List of authors in the library (book libraries only).
    public let authors: [Author]?

    /// List of genres in the library.
    public let genres: [String]?

    /// List of tags in the library.
    public let tags: [String]?

    /// List of series in the library (book libraries only).
    public let series: [Series]?

    /// List of narrators in the library.
    public let narrators: [String]?

    /// List of languages in the library.
    public let languages: [String]?

    /// List of publishers in the library (book libraries only).
    public let publishers: [String]?

    /// List of published decades in the library (book libraries only).
    public let publishedDecades: [String]?

    /// Total number of books in the library (book libraries only).
    public let bookCount: Int?

    /// Total number of authors in the library (book libraries only).
    public let authorCount: Int?

    /// Total number of series in the library (book libraries only).
    public let seriesCount: Int?

    /// Total number of podcasts in the library (podcast libraries only).
    public let podcastCount: Int?

    /// Number of issues found in the library.
    public let numIssues: Int

    /// The time (in ms since POSIX epoch) when the filter data was loaded.
    public let loadedAt: Int

}

extension FilterData: Decodable {}
extension FilterData: Sendable {}
