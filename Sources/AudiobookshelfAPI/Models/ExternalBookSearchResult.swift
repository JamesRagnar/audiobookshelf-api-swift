//
//  ExternalBookSearchResult.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation

public struct ExternalBookSearchResult {

    /// The title of the book.
    public let title: String

    /// The author of the book.
    public let author: String?

    /// The narrator of the audiobook.
    public let narrator: String?

    /// The publisher of the book.
    public let publisher: String?

    /// The year the book was published.
    public let publishedYear: String?

    /// A description of the book.
    public let description: String?

    /// The cover image URL.
    public let cover: String?

    /// The ISBN of the book.
    public let isbn: String?

    /// The ASIN of the book.
    public let asin: String?

    /// The genres of the book.
    public let genres: [String]?

}

extension ExternalBookSearchResult: Decodable {}
extension ExternalBookSearchResult: Sendable {}
