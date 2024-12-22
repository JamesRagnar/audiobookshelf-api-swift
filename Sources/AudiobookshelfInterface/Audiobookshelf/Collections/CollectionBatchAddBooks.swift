//
//  CollectionBatchAddBooks.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import AudiobookshelfModel
import Foundation

/// This endpoint batch adds books to a collection and returns the collection.
public struct CollectionBatchAddBooks: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        struct Body: Encodable {
            
            let books: [String]
            
        }
        
        public let method: RequestMethod = .post

        public let path: String
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data?
        
        public let authentication: AuthenticationType = .bearer

        /// Collection Batch Add Books
        ///
        /// - Parameters:
        ///   - collectionID: The ID of the collection.
        ///   - bookIDs: The IDs of the book library items to add to the collection.
        public init(
            collectionID: String,
            bookIDs: [String]
        ) throws {
            self.path = "/api/collections/\(collectionID)/batch/add"
            self.body = try JSONEncoder().encode(Body(books: bookIDs))
        }
        
    }
    
    // MARK: Response
    
    public typealias Response = Collection
    
    public enum AudiobookshelfError: Error {
        
        case forbidden
        
        case notFound
        
        case internalError
        
    }
        
    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self),
        
        /// A user with update permissions is required to update collections.
        403: .failure(AudiobookshelfError.forbidden),
        
        /// No collection with the specified ID exists.
        404: .failure(AudiobookshelfError.notFound),
        
        /// The provided books array must not be empty.
        500: .failure(AudiobookshelfError.internalError),
        
    ]
    
}

