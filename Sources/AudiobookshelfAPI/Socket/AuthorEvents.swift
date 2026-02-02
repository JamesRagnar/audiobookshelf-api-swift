//
//  AuthorEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import RagnarNetworking

/// An author was created.
public struct AuthorAddedEvent: SocketInboundEvent {
    
    public static let name = "author_added"
    
    public typealias Payload = Author

}

/// An author was updated.
public struct AuthorUpdatedEvent: SocketInboundEvent {
    
    public static let name = "author_updated"
    
    public typealias Payload = Author

}

/// An author was deleted.
public struct AuthorRemovedEvent: SocketInboundEvent {

    public static let name = "author_removed"

    public typealias Payload = EntityRemovedPayload

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
public struct AuthorsAddedEvent: SocketInboundEvent {
    
    public static let name = "authors_added"
    
    public typealias Payload = [Author]

}
