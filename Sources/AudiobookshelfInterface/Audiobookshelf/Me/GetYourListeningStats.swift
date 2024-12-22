//
//  GetYourListeningStats.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-26.
//

import AudiobookshelfModel
import Foundation

/// This endpoint retrieves your listening statistics.
public struct GetYourListeningStats: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .get

        public let path: String = "/api/me/listening-stats"
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer
        
        /// Get Your Listening Stats Parameters
        public init() {}
        
    }
    
    // MARK: Response
    
    public struct Response: Decodable, Sendable {
        
        public let totalTime: Int
        
        public let items: [String: ListenedItem]
        
        public let days: [String: Int]
        
        public let dayOfWeek: [String: Int]
        
        public let today: Int
        
        public let recentSessions: [PlaybackSession]

    }
        
    public static let responseCases: ResponseCases = [

        200: .success(Response.self),
        
    ]
    
}

public extension GetYourListeningStats.Response {
    
    struct ListenedItem: Decodable, Sendable {
        
        /// The ID of the library item you listened to.
        public let id: String
        
        /// The time (in seconds) you listened to the library item.
        public let timeListening: Int
        
        /// The metadata of the library item's media.
        public let mediaMetadata: BookMetadata // TODO: Or Podcast metadata
    }

}
