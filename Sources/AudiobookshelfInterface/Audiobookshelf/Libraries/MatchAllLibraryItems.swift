//
//  MatchAllLibraryItems.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-22.
//

import Foundation

/// This endpoint matches all items in a library using quick match.
/// Quick match populates empty book details and the cover with the first book result from the library's default metadata provider.
/// Does not overwrite details unless the "Prefer matched metadata" server setting is enabled.
public struct MatchAllLibraryItems: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .get

        public let path: String
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer
        
        /// Match All Library Items
        ///
        /// - Parameter libraryID: The ID of the library.
        public init(libraryID: String) {
            self.path = "/api/libraries/\(libraryID)/matchall"
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
        
        /// An admin user is required to match library items.
        403: .failure(AudiobookshelfError.forbidden),
        
        /// The user cannot access the library, or no library with the provided ID exists.
        404: .failure(AudiobookshelfError.notFound),
        
    ]
    
}
