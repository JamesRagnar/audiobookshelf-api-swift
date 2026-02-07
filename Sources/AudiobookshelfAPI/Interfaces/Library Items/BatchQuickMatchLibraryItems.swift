//
//  BatchQuickMatchLibraryItems.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Batch quick match library items to external metadata.
public struct BatchQuickMatchLibraryItems: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/items/batch/quickmatch"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        public init(
            libraryItemIds: [String],
            options: BatchQuickMatchLibraryItems.QuickMatchOptions? = nil
        ) {
            self.body = Payload(
                libraryItemIds: libraryItemIds,
                options: options
            )
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

    }

    public static let responseCases: ResponseMap = [

        .code(200, .noContent),
        .code(403, .error(AudiobookshelfError.forbidden))
    ]

}

extension BatchQuickMatchLibraryItems {

    public struct QuickMatchOptions: Encodable, Sendable {

        public let provider: String?

        public let overrideExistingMetadata: Bool?

        public init(provider: String? = nil, overrideExistingMetadata: Bool? = nil) {
            self.provider = provider
            self.overrideExistingMetadata = overrideExistingMetadata
        }

    }

}

public extension BatchQuickMatchLibraryItems.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let libraryItemIds: [String]

        let options: BatchQuickMatchLibraryItems.QuickMatchOptions?

    }

}
