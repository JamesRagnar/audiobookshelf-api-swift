//
//  RemovePlaylistItem.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import AudiobookshelfModel
import Foundation

/// This endpoint removes an item from a playlist and returns the updated playlist.
/// Then, if the playlist is empty, it will be deleted.
public struct RemovePlaylistItem: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .delete

        public let path: String
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer
        
        /// Remove Playlist Item Parameters
        ///
        /// - Parameters:
        ///   - playlistID: The ID of the playlist.
        ///   - libraryItemID: The ID of the library item the playlist item to remove is for.
        ///   - episodeID: The ID of the podcast episode the playlist item to remove is for.
        public init(
            playlistID: String,
            libraryItemID: String,
            episodeID: String? = nil
        ) {
            var path :String = "/api/playlists/\(playlistID)/item/\(libraryItemID)"
            if let episodeID {
                path += "/\(episodeID)"
            }
            self.path = path
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
        
        /// No playlist with the provided ID exists, or the playlist does not contain the provided item.
        404: .failure(AudiobookshelfError.notFound),
        
    ]
    
}

