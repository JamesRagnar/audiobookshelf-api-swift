//
//  ExternalAuthorSearchResult.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation

public struct ExternalAuthorSearchResult {

    /// The name of the author.
    public let name: String

    /// A description of the author.
    public let description: String?

    /// The author's image URL.
    ///
    /// - Note: The server sends this as `image`, not `imageUrl`.
    public let image: String?

    /// The ASIN of the author.
    public let asin: String?

}

extension ExternalAuthorSearchResult: Decodable {}
extension ExternalAuthorSearchResult: Sendable {}
