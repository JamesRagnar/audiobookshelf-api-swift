//
//  GetAllCollections.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-24.
//

import AudiobookshelfModel
import Foundation

/// This endpoint retrieves all collections.
public struct GetAllCollections: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .get

        public let path: String = "/api/collections"
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer

        /// Get All Collections Parameters
        public init() {}
        
    }
    
    // MARK: Response
    
    public struct Response: Decodable, Sendable {
        
        public let collections: [Collection]

    }
    
    public static let responseCases: ResponseCases = [

        200: .success(Response.self),
        
    ]
    
}
