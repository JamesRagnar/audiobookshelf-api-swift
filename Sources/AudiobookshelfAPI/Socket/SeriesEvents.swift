//
//  SeriesEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import RagnarNetworking

/// A series was created.
public struct SeriesAddedEvent: SocketEvent {

    public static let name = "series_added"

    public typealias Schema = Series

}

/// A series was updated.
public struct SeriesUpdatedEvent: SocketEvent {

    public static let name = "series_updated"

    public typealias Schema = Series

}

/// Multiple series were created.
public struct MultipleSeriesAddedEvent: SocketEvent {

    public static let name = "multiple_series_added"

    public typealias Schema = [Series]

}

/// A series was deleted.
public struct SeriesRemovedEvent: SocketEvent {

    public static let name = "series_removed"

    public typealias Schema = EntityRemovedPayload

}

extension SeriesRemovedEvent {

    public struct EntityRemovedPayload: Decodable, Sendable {

        /// The ID of the entity that was removed.
        public let id: String

        /// The ID of the library.
        public let libraryId: String

    }

}
