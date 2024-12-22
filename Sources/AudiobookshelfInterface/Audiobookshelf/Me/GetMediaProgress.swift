//
//  GetMediaProgress.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import AudiobookshelfModel
import Foundation

/// This endpoint retrieves your media progress that is associated with the given library item ID or podcast episode ID.
public struct GetMediaProgress: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .get

        public let path: String
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
                
        public let authentication: AuthenticationType = .bearer

        /// Get Media Progress Parameters
        ///
        /// - Parameters:
        ///   - libraryItemID: The ID of the library item to retrieve the media progress for.
        ///   - episodeID: The ID of the podcast episode to retrieve the media progress for.
        public init(
            libraryItemID: String,
            episodeID: String?
        ) {
            var path = "/api/me/progress/\(libraryItemID)"
            if let episodeID = episodeID {
                path += "/\(episodeID)"
            }
        
            self.path = path
        }

    }
    
    // MARK: Response
    
    public typealias Response = MediaProgress
    
    public enum AudiobookshelfError: Swift.Error {
        
        case notFound
        
    }
        
    public static let responseCases: ResponseCases = [
        
        /// Success
        200: .success(Response.self),
        
        /// No media progress was found that matches the given IDs.
        404: .failure(AudiobookshelfError.notFound),
        
    ]
    
}
