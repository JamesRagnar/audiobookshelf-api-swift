//
//  UpdatePlaylist.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import AudiobookshelfModel
import Foundation

/// This endpoint updates a playlist and returns it.
public struct UpdatePlaylist: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        struct Body: Encodable {
            
            let name: String
            
            let description: String?
            
            let coverPath: String?
            
            // TODO: Verify items should be included
            // let items: [Item]?
        }
        
        public let method: RequestMethod = .patch

        public let path: String
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data?
        
        public let authentication: AuthenticationType = .bearer
        
        /// Update Playlist Parameters
        ///
        /// - Parameters:
        ///   - playlistID: The ID of the playlist.
        ///   - name: The playlist's name.
        ///   - description: The playlist's description.
        ///   - coverPath: The path of the playlist's cover.
        public init(
            playlistID: String,
            name: String,
            description: String? = nil,
            coverPath: String? = nil
        ) throws {
            self.path = "/api/playlists/\(playlistID)"
            self.body = try JSONEncoder().encode(
                Body(
                    name: name,
                    description: description,
                    coverPath: coverPath
                )
            )
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
