//
//  GetLibraryFilterData.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-22.
//

import AudiobookshelfModel
import Foundation

/// This endpoint returns a library's filter data that can be used for displaying a filter list.
public struct GetLibraryFilterData: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .get

        public let path: String
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer

        /// Get Library Filter Data Parameters
        ///
        /// - Parameter libraryID: The ID of the library.
        public init(libraryID: String) {
            self.path = "/api/libraries\(libraryID)/filterdata"
        }
        
    }
    
    // MARK: Response
    
    public typealias Response = LibraryFilterData
    
    public enum AudiobookshelfError: Error {
        
        case notFound
        
    }
        
    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self),
        
        /// The user cannot access the library, or no library with the provided ID exists.
        404: .failure(AudiobookshelfError.notFound)
        
    ]
    
}
