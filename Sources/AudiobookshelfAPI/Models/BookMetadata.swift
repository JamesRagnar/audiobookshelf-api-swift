//
//  BookMetadata.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct BookMetadata {
    
    /// The title of the book. Will be null if unknown.
    public let title: String?
    
    /// The subtitle of the book. Will be null if there is no subtitle.
    public let subtitle: String?
    
    /// The authors of the book.
    /// - Note: Book Metadata Minified - Removed Attribute
    public let authors: [Author]?
    
    /// The narrators of the audiobook.
    /// - Note: Book Metadata Minified - Removed Attribute
    public let narrators: [String]?
    
    /// The series the book belongs to.
    /// - Note: Book Metadata Minified - Removed Attribute
    /// - Note: Book Metadata Personalized - Added Attribute
    public let series: [Series]?
    
    /// The genres of the book.
    public let genres: [String]
    
    /// The year the book was published. Will be null if unknown.
    public let publishedYear: String?
    
    /// The date the book was published. Will be null if unknown.
    public let publishedDate: String?
    
    /// The publisher of the book. Will be null if unknown.
    public let publisher: String?
    
    /// A description for the book. Will be null if empty.
    public let description: String?
    
    /// The ISBN of the book. Will be null if unknown.
    public let isbn: String?
    
    /// The ASIN of the book. Will be null if unknown.
    public let asin: String?
    
    /// The language of the book. Will be null if unknown.
    public let language: String?
    
    /// Whether the book has been marked as explicit.
    public let explicit: Bool
    
    // MARK: BookMetadata Minified + Expanded
    
    /// The title of the book with any prefix moved to the end.
    /// - Note: Book Metadata Minified - Added Attribute
    /// - Note: Book Metadata Expanded - Added Attribute
    public let titleIgnorePrefix: String?
    
    /// The name of the book's author(s).
    /// - Note: Book Metadata Minified - Added Attribute
    /// - Note: Book Metadata Expanded - Added Attribute
    public let authorName: String?
    
    /// The name of the book's author(s) with last names first.
    /// - Note: Book Metadata Minified - Added Attribute
    /// - Note: Book Metadata Expanded - Added Attribute
    public let authorNameLF: String?
    
    /// The name of the audiobook's narrator(s).
    /// - Note: Book Metadata Minified - Added Attribute
    /// - Note: Book Metadata Expanded - Added Attribute
    public let narratorName: String?
    
    /// The name of the book's series.
    /// - Note: Book Metadata Minified - Added Attribute
    /// - Note: Book Metadata Expanded - Added Attribute
    public let seriesName: String?
    
}

extension BookMetadata: Decodable {
    
    enum CodingKeys: CodingKey {
        case title
        case subtitle
        case authors
        case narrators
        case series
        case genres
        case publishedYear
        case publishedDate
        case publisher
        case description
        case isbn
        case asin
        case language
        case explicit
        case titleIgnorePrefix
        case authorName
        case authorNameLF
        case narratorName
        case seriesName
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        self.authors = try container.decodeIfPresent([Author].self, forKey: .authors)
        self.narrators = try container.decodeIfPresent([String].self, forKey: .narrators)
        self.genres = try container.decode([String].self, forKey: .genres)
        self.publishedYear = try container.decodeIfPresent(String.self, forKey: .publishedYear)
        self.publishedDate = try container.decodeIfPresent(String.self, forKey: .publishedDate)
        self.publisher = try container.decodeIfPresent(String.self, forKey: .publisher)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.isbn = try container.decodeIfPresent(String.self, forKey: .isbn)
        self.asin = try container.decodeIfPresent(String.self, forKey: .asin)
        self.language = try container.decodeIfPresent(String.self, forKey: .language)
        self.explicit = try container.decode(Bool.self, forKey: .explicit)
        self.titleIgnorePrefix = try container.decodeIfPresent(String.self, forKey: .titleIgnorePrefix)
        self.authorName = try container.decodeIfPresent(String.self, forKey: .authorName)
        self.authorNameLF = try container.decodeIfPresent(String.self, forKey: .authorNameLF)
        self.narratorName = try container.decodeIfPresent(String.self, forKey: .narratorName)
        self.seriesName = try container.decodeIfPresent(String.self, forKey: .seriesName)
        
        do {
            // Author returns Series as a single object
            let singleSeries = try container.decode(Series.self, forKey: .series)
            self.series = [singleSeries]
        } catch {
            // It can also be an array of Series
            self.series = try container.decodeIfPresent([Series].self, forKey: .series)
        }
    }
    
}

extension BookMetadata: Sendable {}
