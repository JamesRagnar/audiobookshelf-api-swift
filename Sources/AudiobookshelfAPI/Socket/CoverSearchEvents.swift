//
//  CoverSearchEvents.swift
//  AudiobookshelfAPI
//
//  Created by Claude on 2026-01-29.
//

import Foundation
import RagnarNetworking

/// Cover search result streamed to client.
public struct CoverSearchResult: SocketInboundEvent {

    public static let name = "cover_search_result"

    public typealias Payload = CustomResponse

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
public struct CoverSearchComplete: SocketInboundEvent {

    public static let name = "cover_search_complete"

    public typealias Payload = CustomResponse

}

public extension CoverSearchComplete {

    struct CustomResponse: Decodable, Sendable {

        /// The unique request ID for this search.
        public let requestId: String

    }

}

/// Cover search error occurred.
public struct CoverSearchError: SocketInboundEvent {

    public static let name = "cover_search_error"

    public typealias Payload = CustomResponse

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
public struct CoverSearchProviderError: SocketInboundEvent {

    public static let name = "cover_search_provider_error"

    public typealias Payload = CustomResponse

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
public struct CoverSearchCancelled: SocketInboundEvent {

    public static let name = "cover_search_cancelled"

    public typealias Payload = CustomResponse

}

public extension CoverSearchCancelled {

    struct CustomResponse: Decodable, Sendable {

        /// The unique request ID for this search.
        public let requestId: String

    }

}

/// Authentication failed (invalid token or user).
public struct AuthFailed: SocketInboundEvent {

    public static let name = "auth_failed"

    public typealias Payload = CustomResponse

}

public extension AuthFailed {

    struct CustomResponse: Decodable, Sendable {

        /// Error message describing the failure.
        public let message: String

    }

}
