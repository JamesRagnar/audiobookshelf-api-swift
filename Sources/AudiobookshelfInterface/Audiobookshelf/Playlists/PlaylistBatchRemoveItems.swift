//
//  PlaylistBatchRemoveItems.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import AudiobookshelfModel
import Foundation

/// This endpoint batch removes items from a playlist and returns the updated playlist.
/// Then, if the playlist is empty, it will be deleted.
public struct PlaylistBatchRemoveItems: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public struct Item: Encodable {
            
            /// The ID of the library item the playlist item is for.
            public let libraryItemId: String
            
            /// The ID of the podcast episode the playlist item is for.
            public let episodeId: String?

        }
        
        public let method: RequestMethod = .post

        public let path: String
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data?
        
        public let authentication: AuthenticationType = .bearer
        
        /// Playlist Batch Remove Items Parameters
        ///
        /// - Parameters:
        ///   - playlistID: The ID of the playlist.
        ///   - items: The items to remove from the playlist.
        public init(
            playlistID: String,
            items: [Item]
        ) throws {
            self.path = "/api/playlists/\(playlistID)/batch/remove"
            self.body = try JSONEncoder().encode(items)
        }
        
    }
    
    // MARK: Response
    
    public typealias Response = Playlist
    
    public enum AudiobookshelfError: Error {
        
        case badRequest
        
        case forbidden
        
        case notFound
        
        case internalError
        
    }
        
    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self),
        
        /// One or more of the provided items does not have a libraryItemId.
        400: .failure(AudiobookshelfError.badRequest),
        
        /// The playlist does not belong to the authenticated user.
        403: .failure(AudiobookshelfError.forbidden),
        
        /// No playlist with the provided ID exists.
        404: .failure(AudiobookshelfError.notFound),
        
        /// The provided items array was empty or did not exist.
        500: .failure(AudiobookshelfError.internalError)
        
    ]
    
}

