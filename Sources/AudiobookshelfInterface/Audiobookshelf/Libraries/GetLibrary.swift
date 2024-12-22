//
//  GetLibrary.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-21.
//

import Foundation

/// This endpoint retrieves a library.
public struct GetLibrary: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public enum Include: String {
            case filterData = "filterdata"
        }
        
        public let method: RequestMethod = .get

        public let path: String
        
        public let queryItems: [String: String]?
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer
        
        /// Get Library Parameters
        ///
        /// - Parameters:
        ///   - libraryID: The ID of the library to retrieve.
        ///   - include: A comma separated list of what to include with the library item.
        public init(
            libraryID: String,
            include: Set<Include>?
        ) {
            self.path = "/api/libraries/\(libraryID)"
            
            var queryItems: [String: String] = [:]
            queryItems.setIfPresent("include", include?.joined())
            self.queryItems = queryItems
        }
        
    }
    
    // MARK: Response
    
    public struct Response: Decodable, Sendable {
        
    }
    
    public enum AudiobookshelfError: Error {
        
        ///
        case notFound
        
    }
        
    public static let responseCases: ResponseCases = [

        200: .success(Response.self),
        
        404: .failure(AudiobookshelfError.notFound)
        
    ]
    
}
