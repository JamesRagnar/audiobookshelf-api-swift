//
//  GetCollection.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import AudiobookshelfModel
import Foundation

/// This endpoint retrieves a collection.
public struct GetCollection: Interface {
    
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

        /// Get Collection Parameters
        ///
        /// - Parameters:
        ///   - collectionID: The ID of the collection.
        ///   - include: A comma separated list of what to include with the library item.
        public init(
            collectionID: String,
            include: Set<Include>? = nil
        ) {
            self.path = "/api/collections/\(collectionID)"
            
            var queryItems: [String: String] = [:]
            queryItems.setIfPresent("include", include?.joined())
            self.queryItems = queryItems
        }
        
    }
    
    // MARK: Response
    
    public typealias Response = Collection
    
    public enum AudiobookshelfError: Error {
        
        case notFound
        
    }
        
    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self),
        
        /// No collection with the specified ID exists.
        404: .failure(AudiobookshelfError.notFound)
        
    ]
    
}
