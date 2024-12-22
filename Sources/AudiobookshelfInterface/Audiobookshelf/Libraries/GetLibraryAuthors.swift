//
//  GetLibraryAuthors.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import AudiobookshelfModel
import Foundation

/// This endpoint returns a library's authors.
public struct GetLibraryAuthors: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .get

        public let path: String
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer

        /// Get Library Authors Parameters
        ///
        /// - Parameter libraryID: The ID of the library.
        public init(
            libraryID: String
        ) {
            self.path = "/api/libraries/\(libraryID)/authors"
        }
        
    }
    
    // MARK: Response
    
    public struct Response: Decodable, Sendable {
        
        public let authors: [Author]
        
    }
        
    public static let responseCases: ResponseCases = [

        /// The requested authors.
        200: .success(Response.self),
        
    ]
    
}
