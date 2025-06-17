//
//  ScanLibraryFolders.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-22.
//

import Foundation

/// This endpoint starts a scan of a library's folders for new library items and changes to existing library items.
public struct ScanLibraryFolders: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .post

        public let path: String
        
        public let queryItems: [String : String]?
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer

        /// Scan Library Folders Parameters
        ///
        /// - Parameters:
        ///   - libraryID: The ID of the library.
        ///   - force: Whether to force a rescan for all of a library's items. 0 for false, 1 for true.
        public init(
            libraryID: String,
            force: Bool? = nil
        ) {
            self.path = "/api/libraries/\(libraryID)/scan"
            
            var queryItems: [String: String] = [:]
            queryItems.setIfPresent("force", force?.binaryString)
            self.queryItems = queryItems
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
        
        /// An admin user is required to start a scan.
        403: .failure(AudiobookshelfError.forbidden),
        
        /// The user cannot access the library, or no library with the provided ID exists.
        404: .failure(AudiobookshelfError.notFound),
        
    ]
    
}
