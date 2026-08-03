//
//  GetLibraryItemCover.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-20.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves a library item's cover image.
public struct GetLibraryItemCover: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public typealias Format = ArtworkFormat

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = nil

        /// Get Library Item Cover Request
        ///
        /// - Parameters:
        ///   - itemID: The ID of the library item.
        ///   - options: Scaling and cache-busting options for the requested image.
        public init(
            itemID: String,
            options: ArtworkRequestOptions = .init()
        ) {
            self.path = "/api/items/\(itemID)/cover"
            self.queryItems = options.queryItems
        }

        /// Get Library Item Cover Request
        ///
        /// - Parameters:
        ///   - itemID: The ID of the library item.
        ///   - width: The requested width of the cover image.
        ///   - height: The requested height of the cover image. If null, the image is scaled proportionately.
        ///   - format: The requested format of the image. The default value depends on the request headers.
        ///   - raw: Whether to get the raw cover image file instead of a scaled version.
        ///   - timestamp: Cache-busting timestamp (typically the item's updatedAt value).
        public init(
            itemID: String,
            width: Int? = nil,
            height: Int? = nil,
            format: ArtworkFormat? = nil,
            raw: Bool? = nil,
            timestamp: Int? = nil
        ) {
            self.init(
                itemID: itemID,
                options: ArtworkRequestOptions(
                    width: width,
                    height: height,
                    format: format,
                    timestamp: timestamp,
                    raw: raw
                )
            )
        }

    }

    // MARK: Response

    public enum AudiobookshelfError: Error, Sendable {

        case notFound

        /// The cover could not be read from disk, or could not be resized to the requested
        /// dimensions.
        case internalServerError

    }

    public typealias Response = Data

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        additionalSuccesses: [.exact(204)],
        failures: [
            /// Either no library item exists with the given ID, or the item does not have a cover.
            .code(404, .error(AudiobookshelfError.notFound)),
            .code(500, .error(AudiobookshelfError.internalServerError))
        ]
    )

}
