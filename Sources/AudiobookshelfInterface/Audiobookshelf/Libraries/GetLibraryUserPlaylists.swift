//
//  GetLibraryUserPlaylists.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-22.
//

import AudiobookshelfModel
import Foundation

/// This endpoint returns a library's playlists for the authenticated user.
public struct GetLibraryUserPlaylists: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .get

        public let path: String
        
        public let queryItems: [String: String]?
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer

        /// Get Library User Playlists Parameters
        ///
        /// - Parameters:
        ///   - libraryID: The ID of the library.
        ///   - limit: Limit the number of returned results per page. If 0, no limit will be applied.
        ///   - page: The page number (0 indexed) to request. If there is no limit applied, then page will have no effect and all results will be returned.
        public init(
            libraryID: String,
            limit: Int,
            page: Int
        ) {
            self.path = "/api/libraries/\(libraryID)/playlists"
            self.queryItems = [
                "limit": limit.description,
                "page": page.description,
            ]
        }
        
    }
    
    // MARK: Response
    
    public struct Response: Decodable, Sendable {
        
        /// The requested playlists.
        public let results: [Playlist]
        
        /// The total number of results.
        public let total: Int
        
        /// The limit set in the request.
        public let limit: Int
        
        /// The page set in request.
        public let page: Int

    }
    
    public enum AudiobookshelfError: Error {
        
        case notFound
        
    }
        
    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self),
        
        /// The user cannot access the library, or no library with the provided ID exists.
        404: .failure(AudiobookshelfError.notFound)
        
    ]
    
}
