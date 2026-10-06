//
//  CoverSearchEvents.swift
//  AudiobookshelfAPI
//
//  Created by Claude on 2026-01-29.
//

import Foundation
import RagnarSocketIO

/// Cover search result streamed to client.
/// Streaming cover-search contract requires server 2.30.0+.
public struct CoverSearchResult: SocketEvent {

    public static let name = "cover_search_result"

    public typealias Schema = CustomResponse

}

public extension CoverSearchResult {

    struct CustomResponse: Decodable, Sendable {

        /// The unique request ID for this search.
        public let requestId: String

        /// The cover image URL.
        public let cover: String

        /// The source provider name.
        public let provider: String

    }

}

/// Cover search operation completed.
/// Streaming cover-search contract requires server 2.30.0+.
public struct CoverSearchComplete: SocketEvent {

    public static let name = "cover_search_complete"

    public typealias Schema = CustomResponse

}

public extension CoverSearchComplete {

    struct CustomResponse: Decodable, Sendable {

        /// The unique request ID for this search.
        public let requestId: String

    }

}

/// Cover search error occurred.
/// Streaming cover-search contract requires server 2.30.0+.
public struct CoverSearchError: SocketEvent {

    public static let name = "cover_search_error"

    public typealias Schema = CustomResponse

}

public extension CoverSearchError {

    struct CustomResponse: Decodable, Sendable {

        /// The unique request ID for this search.
        public let requestId: String

        /// Error message.
        public let error: String

    }

}

/// Cover search provider-specific error.
/// Streaming cover-search contract requires server 2.30.0+.
public struct CoverSearchProviderError: SocketEvent {

    public static let name = "cover_search_provider_error"

    public typealias Schema = CustomResponse

}

public extension CoverSearchProviderError {

    struct CustomResponse: Decodable, Sendable {

        /// The unique request ID for this search.
        public let requestId: String

        /// Provider name that failed.
        public let provider: String

        /// Error message from provider.
        public let error: String

    }

}

/// Cover search cancelled by user.
/// Streaming cover-search contract requires server 2.30.0+.
public struct CoverSearchCancelled: SocketEvent {

    public static let name = "cover_search_cancelled"

    public typealias Schema = CustomResponse

}

public extension CoverSearchCancelled {

    struct CustomResponse: Decodable, Sendable {

        /// The unique request ID for this search.
        public let requestId: String

    }

}
