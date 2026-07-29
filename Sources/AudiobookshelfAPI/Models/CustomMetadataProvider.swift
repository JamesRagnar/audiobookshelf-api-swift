//
//  CustomMetadataProvider.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation

/// A custom metadata provider for fetching book/podcast metadata, as sent over the socket.
///
/// The filtered shape: no `url` or `authHeaderValue`, and a `slug`.
///
/// - Important: The REST endpoints send ``StoredCustomMetadataProvider`` instead.
public struct CustomMetadataProvider {

    /// The ID of the custom metadata provider.
    public let id: String

    /// The name of the custom metadata provider.
    public let name: String

    /// The media type this provider is for (book or podcast).
    public let mediaType: String

    /// The slug identifier for the provider (computed from id as "custom-{id}").
    public let slug: String

}

extension CustomMetadataProvider: Decodable {}
extension CustomMetadataProvider: Sendable {}
