//
//  CreatePlaylist.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import AudiobookshelfModel
import Foundation

/// This endpoint creates a playlist and returns it.
public struct CreatePlaylist: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        struct Body: Encodable {
            
            let libraryId: String
            
            let name: String
            
            let description: String?
            
            let coverPath: String?
            
            let items: [Item]?
            
        }
        
        /// An Encodable version of PlaylistItem,
        /// including only the parameters required to add the Item to a Playlist
        public struct Item: Encodable {
            
            /// The ID of the library item the playlist item is for.
            public let libraryItemId: String
            
            /// The ID of the podcast episode the playlist item is for.
            public let episodeId: String?
            
        }
        
        public let method: RequestMethod = .post

        public let path: String = "/api/playlists"
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil

        public let body: Data?
        
        public let authentication: AuthenticationType = .bearer

        /// Create Playlist Parameters
        ///
        /// - Parameters:
        ///   - libraryId: The ID of the library the playlist belongs to.
        ///   - name: The playlist's name.
        ///   - description: The playlist's description.
        ///   - coverPath: The path of the playlist's cover.
        ///   - items: The items in the playlist.
        public init(
            libraryId: String,
            name: String,
            description: String? = nil,
            coverPath: String? = nil,
            items: [Item]? = nil
        ) throws {
            self.body = try JSONEncoder().encode(
                Body(
                    libraryId: libraryId,
                    name: name,
                    description: description,
                    coverPath: coverPath,
                    items: items
                )
            )
        }
        
    }
    
    // MARK: Response
    
    public typealias Response = Playlist
    
    public enum AudiobookshelfError: Error {
        
        case badRequest
        
    }
        
    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self),
        
        /// The provided playlist data was invalid.
        400: .failure(AudiobookshelfError.badRequest),
        
    ]
    
}
