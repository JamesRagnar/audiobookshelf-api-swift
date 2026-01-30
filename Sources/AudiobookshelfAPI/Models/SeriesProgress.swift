//
//  SeriesProgress.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct SeriesProgress {

    /// The IDs of the library items in the series.
    public let libraryItemIds: [String]

    /// The IDs of the library items in the series that are finished.
    public let libraryItemIdsFinished: [String]

    /// Whether the series is finished.
    public let isFinished: Bool

}

extension SeriesProgress: Decodable {}
extension SeriesProgress: Sendable {}
