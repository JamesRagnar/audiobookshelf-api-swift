//
//  Collection.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct Collection {

    /// The ID of the collection.
    public let id: String

    /// The ID of the library the collection belongs to.
    public let libraryId: String

    /// The name of the collection.
    public let name: String?

    /// The collection's description. Will be null if there is none.
    public let description: String?

    /// The books that belong to the collection.
    /// - Note: In non-expanded responses, this is an array of library item IDs
    /// - Note: In expanded responses (Collection Expanded), this is an array of Library Item Expanded objects
    public let books: CollectionBooks

    /// The time (in ms since POSIX epoch) when the collection was last updated.
    public let lastUpdate: Int

    /// The time (in ms since POSIX epoch) when the collection was created.
    public let createdAt: Int

    // MARK: Collection + rssfeed

    /// The collection's currently open RSS feed. Will be null if the collection does not have an open RSS feed.
    /// - Note: Collection rssfeed - Added Attribute
    public let rssFeed: RSSFeed?

}

extension Collection: Decodable {

    enum CodingKeys: CodingKey {
        case id
        case libraryId
        case name
        case description
        case books
        case lastUpdate
        case createdAt
        case rssFeed
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.libraryId = try container.decode(String.self, forKey: .libraryId)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)

        // Handle polymorphic books field: can be either [String] or [LibraryItem]
        // Try to decode as array of LibraryItem first (expanded response)
        if let items = try? container.decode([LibraryItem].self, forKey: .books) {
            self.books = .items(items)
        }
        // Fall back to array of String (non-expanded response)
        else if let ids = try? container.decode([String].self, forKey: .books) {
            self.books = .ids(ids)
        }
        // Neither worked - throw error
        else {
            throw DecodingError.dataCorruptedError(
                forKey: .books,
                in: container,
                debugDescription: "books must be either [String] (non-expanded) or [LibraryItem] (expanded)"
            )
        }

        self.lastUpdate = try container.decode(Int.self, forKey: .lastUpdate)
        self.createdAt = try container.decode(Int.self, forKey: .createdAt)
        self.rssFeed = try container.decodeIfPresent(RSSFeed.self, forKey: .rssFeed)
    }

}

extension Collection: Sendable {}

/// Represents the books in a collection, which can be either an array of IDs or an array of full LibraryItem objects
public enum CollectionBooks {
    /// Array of library item IDs (non-expanded response)
    case ids([String])
    /// Array of full LibraryItem objects (expanded response)
    case items([LibraryItem])

    /// Get the library item IDs, regardless of the representation
    public var ids: [String] {
        switch self {
        case .ids(let ids):
            return ids

        case .items(let items):
            return items.map { $0.id }
        }
    }

    /// Get the full library items if available
    public var items: [LibraryItem]? {
        switch self {
        case .ids:
            return nil

        case .items(let items):
            return items
        }
    }
}

extension CollectionBooks: Sendable {}
