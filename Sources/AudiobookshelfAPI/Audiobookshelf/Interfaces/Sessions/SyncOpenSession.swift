//
//  SyncOpenSession.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-12-03.
//

import Foundation

/// This endpoint syncs the position of an open listening session from the client to the server and returns the session.
public struct SyncOpenSession: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        struct Body: Encodable {
            
            let currentTime: Float
            
            let timeListened: Float
            
            let duration: Float
            
        }
        
        public let method: RequestMethod = .post

        public let path: String
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data?
        
        public let authentication: AuthenticationType = .bearer
        
        /// Sync Open Session Parameters
        ///
        /// - Parameters:
        ///   - sessionID: The ID of the listening session.
        ///   - currentTime: The current time (in seconds) of the playback position.
        ///   - timeListened: The amount of time (in seconds) the user has spent listening since the last session sync.
        ///   - duration: The total duration (in seconds) of the playing item.
        public init(
            sessionID: String,
            currentTime: Float,
            timeListened: Float,
            duration: Float
        ) throws {
            self.path = "/api/session/\(sessionID)/sync"
            
            self.body = try JSONEncoder().encode(
                Body(
                    currentTime: currentTime,
                    timeListened: timeListened,
                    duration: duration
                )
            )
        }
        
    }
    
    // MARK: Response
    
    public typealias Response = String
    
    public enum AudiobookshelfError: Error {
        
        case notFound
        
        case internalServerError
        
    }
        
    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self),
        
        /// No listening session with the provided ID is open, or the session belongs to another user.
        404: .failure(AudiobookshelfError.notFound),
        
        /// There was an error syncing the session.
        500: .failure(AudiobookshelfError.internalServerError),
        
    ]
    
}
