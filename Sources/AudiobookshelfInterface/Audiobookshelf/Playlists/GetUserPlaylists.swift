//
//  GetUserPlaylists.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-24.
//

import AudiobookshelfModel
import Foundation

/// This endpoint retrieves all playlists belonging to the authenticated user.
public struct GetUserPlaylists: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .get

        public let path: String = "/api/playlists"
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer

        /// Get User Playlists Parameters
        public init() {}
        
    }
    
    // MARK: Response
    
    public struct Response: Decodable, Sendable {
        
        public let playlists: [Playlist]

    }
        
    public static let responseCases: ResponseCases = [

        200: .success(Response.self),
        
    ]
    
}
