//
//  GetPodcastEpisode.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-17.
//

import AudiobookshelfModel
import Foundation

/// This endpoint retrieves a podcast episode.
public struct GetPodcastEpisode: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .get

        public let path: String
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer

        public init(
            libraryItemID: String,
            episodeID: String
        ) {
            self.path = "/api/podcasts/\(libraryItemID)/episode/\(episodeID)"
        }
        
    }
    
    // MARK: Response
    
    public typealias Response = PodcastEpisode
    
    public enum AudiobookshelfError: Error {
        
        case forbidden
        
        case notFound
        
        case internalServerError
        
    }
        
    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self),
        
        /// The user is not allowed to access the library item.
        403: .failure(AudiobookshelfError.forbidden),
        
        /// No podcast episode with the given ID exists.
        404: .failure(AudiobookshelfError.notFound),
        
        /// The library item is not a podcast.
        500: .failure(AudiobookshelfError.internalServerError),
        
    ]
    
}

