//
//  GetLibraryItems.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-21.
//

import Foundation
import RagnarNetworking

/// Server-supported sort values for library items.
///
/// Book libraries support the common and book-only values. Podcast libraries
/// support the common and podcast-only values. The server treats `sequence` as
/// meaningful for series-filtered book results and falls back to title sorting
/// for other book queries. Progress sorting uses the authenticated user's
/// progress, with items that have no progress sorted last.
public enum LibraryItemSort: String, CaseIterable, Sendable {

    /// Common to book and podcast libraries.
    case addedAt
    case size
    case birthtimeMs
    case mtimeMs
    case mediaMetadataTitle = "media.metadata.title"
    case random

    /// Supported by book libraries.
    case mediaDuration = "media.duration"
    case mediaMetadataPublishedYear = "media.metadata.publishedYear"
    case mediaMetadataAuthorNameLF = "media.metadata.authorNameLF"
    case mediaMetadataAuthorName = "media.metadata.authorName"
    case sequence
    case progress
    case progressCreatedAt = "progress.createdAt"
    case progressFinishedAt = "progress.finishedAt"

    /// Supported by podcast libraries.
    case mediaMetadataAuthor = "media.metadata.author"
    case mediaNumTracks = "media.numTracks"
}

/// This endpoint returns a library's items, optionally sorted and/or filtered.
public struct GetLibraryItems: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public typealias Sort = LibraryItemSort

        public enum Include: String {

            case rssfeed

        }

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Get Library Items Request
        /// - Parameters:
        ///   - libraryID: The ID of the library.
        ///   - limit: Limit the number of returned results per page. If 0, no limit will be applied.
        /// - page: The page number (0 indexed) to request. If there is no limit applied, then page will have no effect
        /// and all results will be returned.
        ///   - sort: The server-supported field to sort the results by. Valid values depend on the library media type;
        ///     see `LibraryItemSort`.
        ///   - descending: Whether to reverse the sort order. 0 for false, 1 for true.
        ///   - filter: What to filter the results by. See Filtering.
        ///   - minified: Whether to request minified objects.
        ///   - collapseSeries: Whether to collapse books in a series to a single entry.
        ///   - include: A comma separated list of what to include with the library items.
        public init(
            libraryID: String,
            limit: Int? = nil,
            page: Int? = nil,
            sort: Sort? = nil,
            descending: Bool? = nil,
            filter: String? = nil,
            minified: Bool? = nil,
            collapseSeries: Bool? = nil,
            include: Set<Include>? = nil
        ) {
            self.path = "/api/libraries/\(libraryID)/items"

            var queryItems: [URLQueryItem] = []
            queryItems.appendIfPresent("limit", limit?.description)
            queryItems.appendIfPresent("page", page?.description)
            queryItems.appendIfPresent("sort", sort?.rawValue)
            queryItems.appendIfPresent("desc", descending?.binaryString)
            queryItems.appendIfPresent("filter", filter)
            queryItems.appendIfPresent("minified", minified?.binaryString)
            queryItems.appendIfPresent("collapseseries", collapseSeries?.binaryString)
            queryItems.appendIfPresent("include", include?.joined())
            self.queryItems = queryItems
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// The requested library items
        ///  If minified is true, it will be an array of Library Item Minified.
        /// collapseseries will add a Series Num Books as collapsedSeries to the library items, with only one library
        /// item per series.
        ///  However, if there is only one series in the results, they will not be collapsed.
        ///  When filtering by series, media.metadata.series will be replaced by the matching Series Sequence object.
        /// If filtering by series, collapseseries is true, and there are multiple series, such as a subseries, a
        /// seriesSequenceList string attribute is added to collapsedSeries which represents the items in the subseries
        /// that are in the filtered series.
        /// rssfeed will add an RSS Feed Minified object or null as rssFeed to the library items, the item's RSS feed if
        /// it has one open.
        public let results: [LibraryItem]

        /// The total number of results.
        public let total: Int

        /// The limit set in the request.
        public let limit: Int

        /// The page set in request.
        public let page: Int

        /// The sort set in the request. Will not exist if no sort was set.
        public let sortBy: String?

        /// Whether to reverse the sort order.
        public let sortDesc: Bool

        /// The filter set in the request, URL decoded. Will not exist if no filter was set.
        public let filterBy: String?

        /// The media type of the library.
        public let mediaType: MediaType

        ///  Whether minified was set in the request.
        public let minified: Bool

        /// Whether collapseseries was set in the request.
        public let collapseseries: Bool

        /// The requested include.
        public let include: String

    }

    public enum AudiobookshelfError: Error, Sendable {

        /// The `limit` or `page` query parameter was not a non-negative integer.
        case badRequest

        /// You do not have access to this library.
        case forbidden

        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden)),
            /// The user cannot access the library, or no library with the provided ID exists.
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}

public extension GetLibraryItems.Response {

    enum MediaType: String, Decodable, Sendable {

        case book

        case podcast

    }

}
