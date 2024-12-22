//
//  GetYourListeningSessions.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-21.
//

import AudiobookshelfModel
import Foundation

/// This endpoint retrieves your listening sessions.
public struct GetYourListeningSessions: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .get

        public let path: String = ""
        
        public let queryItems: [String : String]?
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer

        
        /// Get Your Listening Sessions Parameters
        /// 
        /// - Parameters:
        ///   - itemsPerPage: The number of listening sessions to retrieve per page.
        ///   - page: The page (0 indexed) to retrieve.
        public init(
            itemsPerPage: Int,
            page: Int
        ) {
            self.queryItems = [
                "itemsPerPage": itemsPerPage.description,
                "page": page.description,
            ]
        }
        
    }
    
    // MARK: Response
    
    public struct Response: Decodable, Sendable {
        
        /// The total number of listening sessions.
        public let total: Int
        
        /// The total number of pages when using this itemsPerPage limit.
        public let numPages: Int
        
        /// The provided itemsPerPage parameter.
        public let itemsPerPage: Int
        
        /// The requested listening sessions.
        public let sessions: [PlaybackSession]
        
    }
        
    public static let responseCases: ResponseCases = [

        200: .success(Response.self),
        
    ]
    
}
