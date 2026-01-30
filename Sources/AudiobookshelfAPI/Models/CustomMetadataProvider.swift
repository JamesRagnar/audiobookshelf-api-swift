//
//  CustomMetadataProvider.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation

/// A custom metadata provider for fetching book/podcast metadata.
///
/// Note: The server filters sensitive fields in `toClientJson()`.
/// The `url` and `authHeaderValue` properties are NOT sent to clients for security.
public struct CustomMetadataProvider {

    /// The ID of the custom metadata provider.
    public let id: String

    /// The name of the custom metadata provider.
    public let name: String

    /// The media type this provider is for (book or podcast).
    public let mediaType: String?

    /// The slug identifier for the provider (computed from id as "custom-{id}").
    public let slug: String

}

extension CustomMetadataProvider: Decodable {}
extension CustomMetadataProvider: Sendable {}
