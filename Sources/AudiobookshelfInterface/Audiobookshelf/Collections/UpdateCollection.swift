//
//  UpdateCollection.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import AudiobookshelfModel
import Foundation

/// This endpoint updates a collection and returns it.
public struct UpdateCollection: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        struct Body: Encodable {
            
            let libraryID: String
            
            let name: String
            
            let description: String?
            
            let books: [String]?
            
        }
        
        public let method: RequestMethod = .patch

        public let path: String
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data?
        
        public let authentication: AuthenticationType = .bearer

        /// Update Collection Parameters
        ///
        /// - Parameters:
        ///   - collectionID: The ID of the collection.
        ///   - libraryID: The ID of the library the collection belongs to.
        ///   - name: The name of the collection.
        ///   - description: The collection's description.
        ///   - books: The IDs of book library items that are in the collection.
        public init(
            collectionID: String,
            libraryID: String,
            name: String,
            description: String? = nil,
            books: [String]? = nil
        ) throws {
            self.path = "/api/collections/\(collectionID)"
            
            self.body = try JSONEncoder().encode(
                Body(
                    libraryID: libraryID,
                    name: name,
                    description: description,
                    books: books
                )
            )
        }
        
    }
    
    // MARK: Response
    
    public typealias Response = Collection
    
    public enum AudiobookshelfError: Error {
        
        case forbidden
        
        case notFound
        
    }
        
    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self),
        
        /// A user with update permissions is required to update collections.
        403: .failure(AudiobookshelfError.forbidden),
        
        /// No collection with the specified ID exists.
        404: .failure(AudiobookshelfError.notFound),
        
    ]
    
}

