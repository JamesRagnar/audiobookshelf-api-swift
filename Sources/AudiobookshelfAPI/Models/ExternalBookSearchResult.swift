//
//  ExternalBookSearchResult.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation

public struct ExternalBookSearchResult {

    /// Series match information returned by metadata providers.
    public struct SeriesMatch: Decodable, Sendable {

        /// The series name.
        public let name: String

        /// The position within the series.
        public let sequence: String?

        private enum CodingKeys: String, CodingKey {
            case name = "series"
            case sequence
        }

    }

    /// The title of the book.
    public let title: String

    /// The subtitle of the book.
    public let subtitle: String?

    /// The author of the book.
    public let author: String?

    /// The narrator of the audiobook.
    public let narrator: String?

    /// The publisher of the book.
    public let publisher: String?

    /// The year the book was published.
    /// Decoded from either a string or integer — FantLab returns an integer.
    public let publishedYear: String?

    /// An HTML description of the book.
    public let description: String?

    /// A plain-text description of the book (HTML tags stripped by the server).
    public let descriptionPlain: String?

    /// The cover image URL.
    public let cover: String?

    /// The ISBN of the book.
    public let isbn: String?

    /// The ASIN of the book.
    public let asin: String?

    /// The genres of the book.
    public let genres: [String]?

    /// The tags of the book (Audible and custom providers only).
    public let tags: [String]?

    /// The series the book belongs to (Audible and custom providers only).
    public let series: [SeriesMatch]?

    /// The language of the book (Audible and custom providers only).
    public let language: String?

    /// The duration of the audiobook in minutes (Audible and custom providers only).
    public let duration: Int?

    /// The regional market identifier (Audible only).
    public let region: String?

    /// The provider rating (Audible only).
    public let rating: String?

    /// Whether the audiobook is abridged (Audible only).
    public let abridged: Bool?

    /// A match confidence score from 0.0 to 1.0 (Audible only, when matching a library item).
    public let matchConfidence: Double?

}

extension ExternalBookSearchResult: Decodable {

    private enum CodingKeys: String, CodingKey {
        case title, subtitle, author, narrator, publisher, publishedYear
        case description, descriptionPlain, cover, isbn, asin
        case genres, tags, series, language, duration, region, rating, abridged, matchConfidence
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        author = try container.decodeIfPresent(String.self, forKey: .author)
        narrator = try container.decodeIfPresent(String.self, forKey: .narrator)
        publisher = try container.decodeIfPresent(String.self, forKey: .publisher)
        // publishedYear is a String in most providers but an Int in FantLab.
        if let stringYear = try? container.decodeIfPresent(String.self, forKey: .publishedYear) {
            publishedYear = stringYear
        } else if let intYear = try? container.decodeIfPresent(Int.self, forKey: .publishedYear) {
            publishedYear = String(intYear)
        } else {
            publishedYear = nil
        }
        description = try container.decodeIfPresent(String.self, forKey: .description)
        descriptionPlain = try container.decodeIfPresent(String.self, forKey: .descriptionPlain)
        cover = try container.decodeIfPresent(String.self, forKey: .cover)
        isbn = try container.decodeIfPresent(String.self, forKey: .isbn)
        asin = try container.decodeIfPresent(String.self, forKey: .asin)
        genres = try container.decodeIfPresent([String].self, forKey: .genres)
        // tags changed from a comma-separated String to [String] in server 2.32.0.
        // Support both formats to maintain the >= 2.26.0 compatibility guarantee.
        if let arrayTags = try? container.decodeIfPresent([String].self, forKey: .tags) {
            tags = arrayTags
        } else if let stringTags = try? container.decodeIfPresent(String.self, forKey: .tags) {
            tags = stringTags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        } else {
            tags = nil
        }
        series = try container.decodeIfPresent([SeriesMatch].self, forKey: .series)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        duration = try container.decodeIfPresent(Int.self, forKey: .duration)
        region = try container.decodeIfPresent(String.self, forKey: .region)
        rating = try container.decodeIfPresent(String.self, forKey: .rating)
        abridged = try container.decodeIfPresent(Bool.self, forKey: .abridged)
        matchConfidence = try container.decodeIfPresent(Double.self, forKey: .matchConfidence)
    }

}

extension ExternalBookSearchResult: Sendable {}
