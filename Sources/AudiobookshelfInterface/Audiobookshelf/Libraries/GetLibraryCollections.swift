//
//  GetLibraryCollections.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-22.
//

import AudiobookshelfModel
import Foundation

/// This endpoint returns a library's collections.
public struct GetLibraryCollections: Interface {
    
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
        
        /// Get Library Collection Parameters
        ///
        /// - Note: Sorting and filtering are not yet implemented.
        ///
        /// - Parameters:
        ///   - libraryID: The ID of the library.
        ///   - limit: Limit the number of returned results per page. If 0, no limit will be applied.
        ///   - page: The page number (0 indexed) to request. If there is no limit applied, then page will have no effect and all results will be returned.
        ///   - sort: What to sort the results by.
        ///   - descending: Whether to reverse the sort order.
        ///   - filter: What to filter the results by.
        ///   - minified: Whether to request minified objects.
        ///   - include: A comma separated list of what to include with the library items.
        public init(
            libraryID: String,
            limit: Int? = nil,
            page: Int? = nil,
            sort: String? = nil,
            descending: Bool? = nil,
            filter: String? = nil,
            minified: Bool? = nil,
            include: Set<Include>? = nil
        ) {
            self.path = "/api/libraries/\(libraryID)/collections"
            
            var queryItems: [String : String] = [:]
            queryItems.setIfPresent("limit", limit?.description)
            queryItems.setIfPresent("page", page?.description)
            queryItems.setIfPresent("sort", sort)
            queryItems.setIfPresent("desc", descending?.binaryString)
            queryItems.setIfPresent("filter", filter)
            queryItems.setIfPresent("minified", minified?.binaryString)
            queryItems.setIfPresent("include", include?.joined())
            self.queryItems = queryItems
        }
        
    }
    
    // MARK: Response
    
    public struct Response: Decodable, Sendable {
        
        /// The requested collections.
        /// If minified is true, the library items contained in the collections will be Library Item Minified.
        /// If rssfeed was requested, an RSS Feed Minified object or null as rssFeed, the collection's RSS feed if it has one open, will be added to the collections.
        public let results: [Collection]
        
        /// The total number of results.
        public let rtotal: Int
        
        /// The limit set in the request.
        public let rlimit: Int
        
        /// The page set in request.
        public let rpage: Int
        
        /// The sort set in the request. Will not exist if no sort was set.
        public let rsortBy: String?
        
        /// Whether to reverse the sort order.
        public let rsortDesc: Bool
        
        /// The filter set in the request, URL decoded. Will not exist if no filter was set.
        public let rfilterBy: String?
        
        /// Whether minified was set in the request.
        public let rminified: Bool
        
        /// The requested include.
        public let rinclude: String
        
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
