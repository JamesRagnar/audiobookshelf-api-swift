import Foundation
import RagnarNetworking

/// This endpoint returns a library's items filtered to an author.
public struct GetLibraryItemsForAuthor: Interface {

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]?

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        public init(
            libraryID: String,
            authorID: String,
            limit: Int? = nil,
            page: Int? = nil,
            sort: String? = nil,
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
                sort: sort,
                descending: descending,
                filter: LibraryItemFilter.author(authorID),
                minified: minified,
                collapseSeries: collapseSeries,
                include: include
            ).queryItems
        }

    }

    public typealias Response = GetLibraryItems.Response

    public static let responses = GetLibraryItems.responses

}
