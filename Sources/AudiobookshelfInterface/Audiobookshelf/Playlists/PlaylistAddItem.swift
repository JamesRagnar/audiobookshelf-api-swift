//
//  PlaylistAddItem.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import AudiobookshelfModel
import Foundation

/// This endpoint adds an item to a playlist and returns the updated playlist.
public struct PlaylistAddItem: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        struct Body: Encodable {
            
            let libraryItemId: String
            
            let episodeId: String?
            
        }
        
        public let method: RequestMethod = .post

        public let path: String
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data?
        
        public let authentication: AuthenticationType = .bearer
        
        /// Playlist Add Item Parameters
        ///
        /// - Parameters:
        ///   - playlistID: The ID of the playlist.
        ///   - libraryItemID: The ID of the library item the playlist item is for.
        ///   - episodeID: The ID of the podcast episode the playlist item is for.
        public init(
            playlistID: String,
            libraryItemID: String,
            episodeID: String? = nil
        ) throws {
            self.path = "/api/playlists/\(playlistID)/item"
            self.body = try JSONEncoder().encode(
                Body(
                    libraryItemId: libraryItemID,
                    episodeId: episodeID
                )
            )
        }
        
    }
    
    // MARK: Response
    
    public typealias Response = Playlist
    
    public enum AudiobookshelfError: Error {
        
        case badRequest
        
        case forbidden
        
        case notFound
        
    }
        
    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self),
        
        /// No library item with the provided ID exists, the library item is in a different library from the playlist, the library item is already in the playlist, the library item is not a podcast and an episodeId was provided, the library item is a podcast and an episodeId was not provided, or no podcast episode with the provided ID exists in the library item.
        400: .failure(AudiobookshelfError.badRequest),
        
        /// The playlist does not belong to the authenticated user.
        403: .failure(AudiobookshelfError.forbidden),
        
        /// No playlist with the provided ID exists.    
        404: .failure(AudiobookshelfError.notFound),
        
    ]
    
}

