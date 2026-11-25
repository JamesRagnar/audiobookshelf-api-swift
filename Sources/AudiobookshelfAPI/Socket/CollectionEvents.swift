//
//  CollectionEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import RagnarSocketIO

/// A collection was created.
/// On server 2.38.0+, delivered only to connected sockets belonging to the user performing the mutation.
/// Collections remain shared; other users must refresh REST state to observe changes.
/// The payload is permission-filtered for that user; no event is emitted if its representation is null.
/// The event name and non-null payload schema are unchanged.
public struct CollectionAddedEvent: SocketEvent {

    public static let name = "collection_added"

    public typealias Schema = Collection

}

/// A collection was updated.
/// On server 2.38.0+, delivered only to connected sockets belonging to the user performing the mutation.
/// Collections remain shared; other users must refresh REST state to observe changes.
/// The payload is permission-filtered for that user; no event is emitted if its representation is null.
/// The event name and non-null payload schema are unchanged.
public struct CollectionUpdatedEvent: SocketEvent {

    public static let name = "collection_updated"

    public typealias Schema = Collection

}

/// A collection was deleted.
/// On server 2.38.0+, delivered only to connected sockets belonging to the user performing the mutation.
/// Collections remain shared; other users must refresh REST state to observe changes.
/// The payload is permission-filtered for that user; no event is emitted if its representation is null.
/// The event name and non-null payload schema are unchanged.
public struct CollectionRemovedEvent: SocketEvent {

    public static let name = "collection_removed"

    public typealias Schema = Collection

}
