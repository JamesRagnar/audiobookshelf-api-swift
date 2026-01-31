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

/// Authors were created.
public struct AuthorsAddedEvent: SocketEvent {
    
    public static let name = "authors_added"
    
    public typealias Schema = [Author]

}
