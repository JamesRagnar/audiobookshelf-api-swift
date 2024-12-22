//
//  CreatePlaylistFromCollection.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import AudiobookshelfModel
import Foundation

/// This endpoint creates a playlist from a collection. The newly created playlist is returned.
public struct CreatePlaylistFromCollection: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .post

        public let path: String
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer
        
        /// Create Playlist from Collection Parameters
        ///
        /// - Parameter collectionID: The ID of the collection.
        public init(collectionID: String) {
            self.path = "/api/playlists/collection/\(collectionID)"
        }
        
    }
    
    // MARK: Response
    
    public typealias Response = Playlist
    
    public enum AudiobookshelfError: Error {
        
        case badRequest
        
        case notFound
        
    }
        
    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self),
        
        /// The user cannot access any books contained in the collection.
        400: .failure(AudiobookshelfError.badRequest),
        
        /// No collection with the given ID exists.
        404: .failure(AudiobookshelfError.notFound),
        
    ]
    
}

