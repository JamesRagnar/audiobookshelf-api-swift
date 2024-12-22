//
//  SearchLibrary.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import AudiobookshelfModel
import Foundation

/// This endpoint searches a library for the query and returns the results.
public struct SearchLibrary: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .get

        public let path: String
        
        public let queryItems: [String: String]?
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer
        
        /// Search Library Parameters
        ///
        /// - Parameters:
        ///   - libraryID: The ID of the library.
        ///   - query: The search query, automatically URL Encoded
        ///   - limit: Limit the number of returned results.
        public init(
            libraryID: String,
            query: String,
            limit: Int? = nil
        ) {
            self.path = "/api/libraries/\(libraryID)/search"
            
            var queryItems: [String: String] = [:]
            queryItems["q"] = query
            queryItems.setIfPresent("limit", limit?.description)
            self.queryItems = queryItems
        }
    }
    
    // MARK: Response
    
    public struct Response: Decodable, Sendable {
        
        /// The item results of the search. This attribute will be book or podcast depending on the library's media type.
        public let book: [LibraryItemSearchResult]?
        
        /// The item results of the search. This attribute will be book or podcast depending on the library's media type.
        public let podcast: [LibraryItemSearchResult]?
        
        /// The tag results of the search.
        // public let tags: [String]? // TODO: Dictionary?
        
        /// The series results of the search.
        public let series: [SeriesSearchResult]?
        
        /// The author results of the search.
        public let authors: [Author]?
        
    }
    
    public enum AudiobookshelfError: Error {
        
        case badRequest
        
        case notFound
        
    }
    
    public static let responseCases: ResponseCases = [
        
        /// Success
        200: .success(Response.self),
        
        /// No query string.
        400: .failure(AudiobookshelfError.badRequest),
        
        /// The user cannot access the library, or no library with the provided ID exists.
        404: .failure(AudiobookshelfError.notFound),
        
    ]

}

public extension SearchLibrary.Response {
    
    struct LibraryItemSearchResult: Decodable, Sendable {
        
        /// The matched library item.
        public let libraryItem: LibraryItem
        
        /// What the library item was matched on.
        public let matchKey: String?
        
        /// The text in the library item that the query matched to.
        public let matchText: String?
        
    }
    
    struct SeriesSearchResult: Decodable, Sendable {
        
        public let series: Series
        
        public let books: [LibraryItem]
        
    }

}
