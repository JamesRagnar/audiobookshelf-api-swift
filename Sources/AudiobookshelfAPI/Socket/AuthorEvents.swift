//
//  AuthorEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import RagnarNetworking

/// An author was created.
public struct AuthorAddedEvent: SocketEvent {

    public static let name = "author_added"

    public typealias Schema = Author

}

/// An author was updated.
public struct AuthorUpdatedEvent: SocketEvent {

    public static let name = "author_updated"

    public typealias Schema = Author

}

/// An author was deleted.
public struct AuthorRemovedEvent: SocketEvent {

    public static let name = "author_removed"

    public typealias Schema = EntityRemovedPayload

}

extension AuthorRemovedEvent {

    public struct EntityRemovedPayload: Decodable, Sendable {

        /// The ID of the entity that was removed.
        public let id: String

        /// The ID of the library.
        public let libraryId: String

    }

}

/// The book count changed for one or more authors during a library scan.
///
/// Emitted in a single batch once a scan finishes, so `authors` may cover many authors at once.
/// Authors left with no books are omitted here and reported through `AuthorRemovedEvent` instead.
///
/// - Note: Requires server `>= 2.36.0`.
public struct AuthorsNumBooksUpdatedEvent: SocketEvent {

    public static let name = "authors_num_books_updated"

    public typealias Schema = Payload

}

extension AuthorsNumBooksUpdatedEvent {

    public struct Payload: Decodable, Sendable {

        /// The ID of the library that was scanned.
        public let libraryId: String

        /// The authors whose book counts changed.
        public let authors: [AuthorNumBooks]

        public struct AuthorNumBooks: Decodable, Sendable {

            /// The ID of the author.
            public let id: String

            /// The new number of books associated with the author.
            public let numBooks: Int

        }

    }

}
