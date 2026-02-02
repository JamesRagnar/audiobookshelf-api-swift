//
//  SeriesEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import RagnarNetworking

/// A series was created.
public struct SeriesAddedEvent: SocketInboundEvent {
    
    public static let name = "series_added"
    
    public typealias Payload = Series

}

/// A series was updated.
public struct SeriesUpdatedEvent: SocketInboundEvent {
    
    public static let name = "series_updated"
    
    public typealias Payload = Series

}

/// Multiple series were created.
public struct MultipleSeriesAddedEvent: SocketInboundEvent {

    public static let name = "multiple_series_added"

    public typealias Payload = [Series]

}

/// A series was deleted.
public struct SeriesRemovedEvent: SocketInboundEvent {

    public static let name = "series_removed"

    public typealias Payload = EntityRemovedPayload

}

extension SeriesRemovedEvent {

    public struct EntityRemovedPayload: Decodable, Sendable {

        /// The ID of the entity that was removed.
        public let id: String

        /// The ID of the library.
        public let libraryId: String

    }

}
