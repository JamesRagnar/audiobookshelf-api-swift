//
//  CollectionRemoveBook.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import Foundation
import RagnarNetworking

/// Remove a book from a collection.
public struct CollectionRemoveBook: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data? = nil

        public let authentication: AuthenticationType = .bearer

        /// Remove Book from Collection Parameters
        ///
        /// - Parameters:
        ///   - collectionID: The ID of the collection.
        ///   - bookID: The ID of the library item to remove.
        ///             Note: Despite the name, pass the libraryItemId here.
        public init(
            collectionID: String,
            bookID: String
        ) {
            self.path = "/api/collections/\(collectionID)/book/\(bookID)"
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

