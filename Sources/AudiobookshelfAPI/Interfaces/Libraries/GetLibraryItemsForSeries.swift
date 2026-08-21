import Foundation
import RagnarNetworking

/// This endpoint returns a library's items filtered to a series.
public struct GetLibraryItemsForSeries: Interface {

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        public init(
            libraryID: String,
            seriesID: String,
            limit: Int? = nil,
            page: Int? = nil,
            descending: Bool? = nil,
            minified: Bool? = nil,
            collapseSeries: Bool? = nil,
            include: Set<GetLibraryItems.Request.Include>? = nil
        ) {
            path = "/api/libraries/\(libraryID)/items"
            queryItems = GetLibraryItems.Request(
                libraryID: libraryID,
                limit: limit,
                page: page,
                sort: "sequence",
                descending: descending,
                filter: LibraryItemFilter.series(seriesID),
                minified: minified,
                collapseSeries: collapseSeries,
                include: include
            ).queryItems
        }

    }

    public typealias Response = GetLibraryItems.Response

    public static let responses = GetLibraryItems.responses

}
