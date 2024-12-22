//
//  GetAllLibraries.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import AudiobookshelfModel
import Foundation

/// This endpoint retrieves all libraries accessible to the user.
public struct GetAllLibraries: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .get

        public let path: String = "/api/libraries"
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer

        /// Get All Libraries Parameters
        public init() {}
        
    }
    
    // MARK: Response
    
    public struct Response: Decodable, Sendable {
        
        public let libraries: [Library]
        
    }
    
    public static let responseCases: ResponseCases = [

        /// The requested libraries.
        200: .success(Response.self),
        
    ]
    
}
