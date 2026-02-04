//
//  CollectionAddBook.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import Foundation
import RagnarNetworking

/// This endpoint adds a book to a collection and returns the collection.
public struct CollectionAddBook: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .post

        public let path: String
        
        public let queryItems: [String : String?]? = nil
        
        public let headers: [String : String]? = nil
        
        public typealias Body = Payload

        public let body: Body?
        
        public let authentication: AuthenticationType = .bearer
        
        /// Collection Add Book Parameters
        ///
        /// - Parameters:
        ///   - collectionID: The ID of the collection.
        ///   - bookID: The ID of the book library item to add to the collection.
        public init(
            collectionID: String,
            bookID: String
        ) {
            self.path = "/api/collections/\(collectionID)/book"

            self.body = Payload(id: bookID)
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
        
        /// The provided library item ID could not be found, is in a different library, or is already in the collection.
        500: .failure(AudiobookshelfError.internalError),
        
    ]
    
}

public extension CollectionAddBook.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let id: String

    }

}
