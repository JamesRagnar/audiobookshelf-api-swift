//
//  GetPlaylist.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import AudiobookshelfModel
import Foundation

/// This endpoint retrieves a playlist.
public struct GetPlaylist: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .get

        public let path: String
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer

        /// Get Playlist Parameters
        ///
        /// - Parameter playlistID: The ID of the playlist.
        public init(playlistID: String) {
            self.path = "/api/playlists/\(playlistID)"
        }
        
    }
    
    // MARK: Response
    
    public typealias Response = Playlist
    
    public enum AudiobookshelfError: Error {
        
        case forbidden
        
        case notFound
        
    }
        
    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self),
        
        /// The playlist does not belong to the authenticated user.
        403: .failure(AudiobookshelfError.forbidden),
        
        /// No playlist with the provided ID exists.
        404: .failure(AudiobookshelfError.notFound),
        
    ]
    
}

