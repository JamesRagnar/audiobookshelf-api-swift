//
//  CustomMetadataProvider.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation

public struct CustomMetadataProvider {

    /// The ID of the custom metadata provider.
    public let id: String

    /// The name of the custom metadata provider.
    public let name: String

    /// The URL of the custom metadata provider.
    public let url: String

    /// The media type this provider is for (book or podcast).
    public let mediaType: String?

    /// The slug identifier for the provider.
    public let slug: String

}

extension CustomMetadataProvider: Decodable {}
extension CustomMetadataProvider: Sendable {}
