//
//  GetLibrarySeries.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-22.
//

import AudiobookshelfModel
import Foundation

/// This endpoint returns a library's series.
public struct GetLibrarySeries: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public enum Include: String {
            
            case rssfeed
            
        }
        public enum Sort: String {
            
            case numBooks
            
            case totalDuration
            
            case addedAt
            
        }
        
        public let method: RequestMethod = .get

        public let path: String
        
        public let queryItems: [String: String]?
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer
        
        /// Get Library Series Parameters
        /// - Parameters:
        ///   - libraryID: The ID of the library.
        ///   - limit: Limit the number of returned results per page. Must be greater than 0.
        ///   - page: The page number (0 indexed) to request.
        ///   - sort: What to sort the results by. By default, the results will be sorted by series name.
        ///   - descending: Whether to reverse the sort order.
        ///   - filter: What to filter the results by. The issues and feed-open filters are not available for this endpoint.
        ///   - include: A comma separated list of what to include with the library items.
        public init(
            libraryID: String,
            limit: Int,
            page: Int? = nil,
            sort: Sort? = nil,
            descending: Bool? = nil,
            filter: String? = nil,
            include: Set<Include>? = nil
        ) {
            self.path = "/api/libraries/\(libraryID)/series"
            
            var queryItems: [String: String] = [:]
            queryItems.setIfPresent("limit", limit.description)
            queryItems.setIfPresent("page", page?.description)
            queryItems.setIfPresent("sort", sort?.rawValue)
            queryItems.setIfPresent("desc", descending?.binaryString)
            queryItems.setIfPresent("filter", filter)
            queryItems.setIfPresent("include", include?.joined())
            self.queryItems = queryItems
        }
        
    }
    
    // MARK: Response
    
    public struct Response: Decodable, Sendable {
        
        /// The requested series.
        /// If minified is true, the library items contained in the series will be Library Item Minified.
        /// If rssfeed was requested, an RSS Feed Minified object or null as rssFeed, the series' RSS feed if it has one open, will be added to the series.
        public let results: [Series]
        
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
        
        /// Whether minified was set in the request.
        public let minified: Bool
        
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
