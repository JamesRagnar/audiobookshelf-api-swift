//
//  StoredCustomMetadataProvider.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-07-28.
//

import Foundation

/// The stored database row for a custom metadata provider, as returned by the REST endpoints.
///
/// Exposes `url` and `authHeaderValue`, and carries no `slug`. ``CustomMetadataProvider`` is the
/// filtered shape used by the socket events.
public struct StoredCustomMetadataProvider {

    /// The ID of the provider.
    public let id: String

    /// The name of the provider.
    public let name: String

    /// The media type the provider applies to.
    public let mediaType: String

    /// The provider's endpoint URL.
    public let url: String

    /// The value sent in the Authorization header, when one was configured.
    public let authHeaderValue: String?

}

extension StoredCustomMetadataProvider: Decodable {}
extension StoredCustomMetadataProvider: Sendable {}
