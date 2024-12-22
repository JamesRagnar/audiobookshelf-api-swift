//
//  GetLibraryItems.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-21.
//

import AudiobookshelfModel
import Foundation

/// This endpoint returns a library's items, optionally sorted and/or filtered.
public struct GetLibraryItems: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public enum Include: String {
            
            case rssfeed
            
        }
        
        public let method: RequestMethod = .get
        
        public let path: String
        
        public let queryItems: [String : String]?
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer
        
        /// Get Library Items Parameters
        /// - Parameters:
        ///   - libraryID: The ID of the library.
        ///   - limit: Limit the number of returned results per page. If 0, no limit will be applied.
        ///   - page: The page number (0 indexed) to request. If there is no limit applied, then page will have no effect and all results will be returned.
        ///   - sort: What to sort the results by. Specify the attribute to sort by using JavaScript object notation.
        ///   - descending: Whether to reverse the sort order. 0 for false, 1 for true.
        ///   - filter: What to filter the results by. See Filtering.
        ///   - minified: Whether to request minified objects.
        ///   - collapseSeries: Whether to collapse books in a series to a single entry.
        ///   - include: A comma separated list of what to include with the library items.
        public init(
            libraryID: String,
            limit: Int? = nil,
            page: Int? = nil,
            sort: String? = nil,
            descending: Bool? = nil,
            filter: String? = nil,
            minified: Bool? = nil,
            collapseSeries: Bool? = nil,
            include: Set<Include>? = nil
        ) {
            self.path = "/api/libraries/\(libraryID)/items"
            
            var queryItems: [String: String] = [:]
            queryItems.setIfPresent("limit", limit?.description)
            queryItems.setIfPresent("page", page?.description)
            queryItems.setIfPresent("sort", sort)
            queryItems.setIfPresent("desc", descending?.binaryString)
            queryItems.setIfPresent("filter", filter)
            queryItems.setIfPresent("minified", minified?.binaryString)
            queryItems.setIfPresent("collapseseries", collapseSeries?.binaryString)
            queryItems.setIfPresent("include", include?.joined())
            self.queryItems = queryItems
        }
        
    }
    
    // MARK: Response
    
    public struct Response: Decodable, Sendable {
        
        /// The requested library items
        ///  If minified is true, it will be an array of Library Item Minified.
        ///  collapseseries will add a Series Num Books as collapsedSeries to the library items, with only one library item per series.
        ///  However, if there is only one series in the results, they will not be collapsed.
        ///  When filtering by series, media.metadata.series will be replaced by the matching Series Sequence object.
        ///  If filtering by series, collapseseries is true, and there are multiple series, such as a subseries, a seriesSequenceList string attribute is added to collapsedSeries which represents the items in the subseries that are in the filtered series.
        ///  rssfeed will add an RSS Feed Minified object or null as rssFeed to the library items, the item's RSS feed if it has one open.
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
    
    public enum AudiobookshelfError: Error {
        
        case notFound
        
    }
    
    public static let responseCases: ResponseCases = [
        
        /// Success
        200: .success(Response.self),
        
        /// The user cannot access the library, or no library with the provided ID exists.
        404: .failure(AudiobookshelfError.notFound)
        
    ]
    
}

public extension GetLibraryItems.Response {
    
    enum MediaType: String, Decodable, Sendable {
        
        case book
        
        case podcast
        
    }
    
}
