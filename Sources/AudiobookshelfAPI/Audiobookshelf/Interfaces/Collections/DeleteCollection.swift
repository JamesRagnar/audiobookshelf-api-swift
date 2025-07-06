//
//  DeleteCollection.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import Foundation

/// This endpoint deletes a collection from the database.
public struct DeleteCollection: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .delete

        public let path: String
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer

        /// Delete Collection Parameters
        ///
        /// - Parameter collectionID: The ID of the collection.
        public init(collectionID: String) {
            self.path = "/api/collections/\(collectionID)"
        }
        
    }
    
    // MARK: Response
    
    public typealias Response = String
    
    public enum AudiobookshelfError: Error {
        
        case forbidden
        
        case notFound
        
    }
        
    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self),
        
        /// A user with delete permissions is required to delete a collection.
        403: .failure(AudiobookshelfError.forbidden),
        
        /// No collection with the specified ID exists.
        404: .failure(AudiobookshelfError.notFound),
        
    ]
    
}

