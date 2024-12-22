//
//  GetLibraryItem.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-20.
//

import AudiobookshelfModel
import Foundation

/// This endpoint retrieves a library item.
public struct GetLibraryItem: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public enum IncludeOption: String {
            
            case progress
            
            case rssfeed
            
            case authors
            
            case downloads
            
        }
        
        public let method: RequestMethod = .get
        
        public let path: String
        
        public let queryItems: [String : String]?
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer

        /// Get Library Item Parameters
        ///
        /// - Parameters:
        ///   - itemID: The ID of the library item to retrieve.
        ///   - expanded: Whether to return Library Item Expanded instead.
        ///   - include: A list of what to include with the library item. expanded must be `true` for include to have an effect.
        ///   - episode: If requesting `progress` for a podcast, the episode ID to get progress for.
        public init(
            itemID: String,
            expanded: Bool? = nil,
            include: Set<IncludeOption>? = nil,
            episode: String? = nil
        ) {
            self.path = "/api/items/\(itemID)"

            var queryItems: [String: String] = [:]
            queryItems.setIfPresent("expanded", expanded?.binaryString)
            queryItems.setIfPresent("include", include?.joined())
            queryItems.setIfPresent("episode", episode)
            self.queryItems = queryItems
        }
        
    }
    
    // MARK: Response
    
    public typealias Response = LibraryItem
    
    public static let responseCases: ResponseCases = [
        
        /// Library Item or, if expanded was requested, Library Item Expanded with optional extra attributes.
        200: .success(Response.self),
        
    ]
    
}

