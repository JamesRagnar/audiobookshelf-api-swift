//
//  CollectionRemoveBook.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import AudiobookshelfModel
import Foundation

/// This endpoint removes a book from a collection and returns the collection.
public struct CollectionRemoveBook: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .delete

        public let path: String
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer
        
        /// Collection Remove Book Parameters
        ///
        /// - Parameters:
        ///   - collectionID: The ID of the collection.
        ///   - bookID: The ID of the book library item to remove from the collection.
        public init(
            collectionID: String,
            bookID: String
        ) {
            self.path = "/api/collections/\(collectionID)/books/\(bookID)"
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
        
        /// A user with delete permissions is required to remove a book from a collection.
        403: .failure(AudiobookshelfError.forbidden),
        
        /// No collection with the specified ID exists.
        404: .failure(AudiobookshelfError.notFound),
        
    ]
    
}

