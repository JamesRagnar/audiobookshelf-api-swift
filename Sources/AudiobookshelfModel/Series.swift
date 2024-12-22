//
//  Series.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct Series {

    /// The ID of the series.
    public let id: String
    
    /// The name of the series.
    public let name: String
    
    /// A description for the series. Will be null if there is none.
    /// - Note: Series Books - Removed Attribute
    /// - Note: Series Num Books - Removed Attribute
    /// - Note: Series Sequence - Removed Attribute
    public let description: String?
    
    /// The time (in ms since POSIX epoch) when the series was added.
    /// - Note: Series Num Books - Removed Attribute
    /// - Note: Series Sequence - Removed Attribute
    public let addedAt: Int?
    
    /// The time (in ms since POSIX epoch) when the series was last updated.
    /// - Note: Series Books - Removed Attribute
    /// - Note: Series Num Books - Removed Attribute
    /// - Note: Series Sequence - Removed Attribute
    public let updatedAt: Int?
    
    // MARK: Series Num Books + Books
    
    /// The name of the series with any prefix moved to the end.
    /// - Note: Series Books - Added Attribute
    /// - Note: Series Num Books - Added Attribute
    public  let nameIgnorePrefix: String?
    
    // MARK: Series Num Books
    
    /// The IDs of the library items in the series.
    /// - Note: Series Num Books - Added Attribute
    public let libraryItemIds: [String]?
    
    /// The number of books in the series.
    /// - Note: Series Num Books - Added Attribute
    public let numBooks: Int?
    
    // MARK: Series Books
    
    /// The name of the series with any prefix removed.
    /// - Note: Series Books - Added Attribute
    public let nameIgnorePrefixSort: String?
    
    /// Will always be series.
    /// - Note: Series Books - Added Attribute
    public let type: String?
    
    /// The library items that contain the books in the series. A sequence attribute that denotes the position in the series the book is in, is tacked on.
    /// - Note: Series Books - Added Attribute
    /// - Note: Series Personalized - Added Attribute
    public let books: [LibraryItem]?
    
    /// The combined duration (in seconds) of all books in the series.
    /// - Note: Series Books - Added Attribute
    public let totalDuration: Float?
    
    // MARK: Series Sequence
    
    /// The position in the series the book is.
    /// - Note: Series Sequence - Added Attribute
    public let sequence: String?
    
    // MARK: Series Progress
    
    /// If progress was requested, the series' progress.
    public let progress: SeriesProgress?
    
    /// If rssfeed was requested, the series' open RSS feed. Will be null if the series' RSS feed is closed.
    public let rssFeed: RSSFeed?
    
    // MARK: Series Author

    /// The items in the series. Each library item's media's metadata will have a series attribute, a Series Sequence, which is the matching series.
    public let items: [LibraryItem]?
    
    // MARK: Series Personalized
    
    /// Whether the user has started listening to the series.
    /// - Note: Series Personalized - Added Attribute
    public let inProgress: Bool?
    
    /// Whether the user has started listening to the series, but has not finished it.
    /// - Note: Series Personalized - Added Attribute
    public let hasActiveBook: Bool?
    
    /// Whether the series has been marked to hide it from the "Continue Series" shelf.
    /// - Note: Series Personalized - Added Attribute
    public let hideFromContinueListening: Bool?
    
    /// The latest time (in ms since POSIX epoch) when the progress of a book in the series was updated.
    /// - Note: Series Personalized - Added Attribute
    public let bookInProgressLastUpdate: Int?
    
    /// The first book in the series (by sequence) to have not been started or finished.
    /// Will be null if the user has started or finished all books in the series.
    /// This library item will also have a seriesSequence attribute.
    /// - Note: Series Personalized - Added Attribute
    /// - Important: If present, will be single item in array. `LibraryItem` contained in Array to break circular reference cycle
     public let firstBookUnread: [LibraryItem]?

}

extension Series: Decodable {
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case description
        case addedAt
        case updatedAt
        case nameIgnorePrefix
        case libraryItemIds
        case numBooks
        case nameIgnorePrefixSort
        case type
        case books
        case totalDuration
        case sequence
        case progress
        case rssFeed
        case items
        case inProgress
        case hasActiveBook
        case hideFromContinueListening
        case bookInProgressLastUpdate
        case firstBookUnread
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.addedAt = try container.decodeIfPresent(Int.self, forKey: .addedAt)
        self.updatedAt = try container.decodeIfPresent(Int.self, forKey: .updatedAt)
        self.nameIgnorePrefix = try container.decodeIfPresent(String.self, forKey: .nameIgnorePrefix)
        self.libraryItemIds = try container.decodeIfPresent([String].self, forKey: .libraryItemIds)
        self.numBooks = try container.decodeIfPresent(Int.self, forKey: .numBooks)
        self.nameIgnorePrefixSort = try container.decodeIfPresent(String.self, forKey: .nameIgnorePrefixSort)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.books = try container.decodeIfPresent([LibraryItem].self, forKey: .books)
        self.totalDuration = try container.decodeIfPresent(Float.self, forKey: .totalDuration)
        self.sequence = try container.decodeIfPresent(String.self, forKey: .sequence)
        self.progress = try container.decodeIfPresent(SeriesProgress.self, forKey: .progress)
        self.rssFeed = try container.decodeIfPresent(RSSFeed.self, forKey: .rssFeed)
        self.items = try container.decodeIfPresent([LibraryItem].self, forKey: .items)
        self.inProgress = try container.decodeIfPresent(Bool.self, forKey: .inProgress)
        self.hasActiveBook = try container.decodeIfPresent(Bool.self, forKey: .hasActiveBook)
        self.hideFromContinueListening = try container.decodeIfPresent(Bool.self, forKey: .hideFromContinueListening)
        self.bookInProgressLastUpdate = try container.decodeIfPresent(Int.self, forKey: .bookInProgressLastUpdate)
        let firstBookUnread = try container.decodeIfPresent(LibraryItem.self, forKey: .firstBookUnread)
        self.firstBookUnread = firstBookUnread != nil ? [firstBookUnread!] : nil
    }
}

extension Series: Sendable {}
