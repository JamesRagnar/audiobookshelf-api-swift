//
//  ArtworkRequestOptions.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-07-10.
//

import Foundation

/// Shared scaling and cache-busting options for public artwork requests.
///
/// Used by endpoints that serve a library item's cover or an author's image.
public struct ArtworkRequestOptions: Sendable {

    /// The requested width of the image.
    public var width: Int?

    /// The requested height of the image. If nil, the image is scaled proportionately.
    public var height: Int?

    /// The requested format of the image. The default value depends on the request headers.
    public var format: ArtworkFormat?

    /// Cache-busting timestamp (typically the resource's updatedAt value).
    public var timestamp: Int?

    /// Whether to get the raw image file instead of a scaled version.
    public var raw: Bool?

    public init(
        width: Int? = nil,
        height: Int? = nil,
        format: ArtworkFormat? = nil,
        timestamp: Int? = nil,
        raw: Bool? = nil
    ) {
        self.width = width
        self.height = height
        self.format = format
        self.timestamp = timestamp
        self.raw = raw
    }

    /// Serializes these options to query items, omitting `raw` entirely unless it is `true`.
    var queryItems: [String: String?] {
        var queryItems: [String: String?] = [:]
        queryItems.setIfPresent("width", width?.description)
        queryItems.setIfPresent("height", height?.description)
        queryItems.setIfPresent("format", format?.rawValue)
        queryItems.setIfPresent("ts", timestamp?.description)
        if raw == true {
            queryItems["raw"] = "1"
        }
        return queryItems
    }

}
