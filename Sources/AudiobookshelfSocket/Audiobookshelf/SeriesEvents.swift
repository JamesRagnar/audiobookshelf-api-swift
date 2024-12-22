//
//  SeriesEvents.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-12.
//

import Foundation
import AudiobookshelfModel

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
