//
//  CloseOpenSession.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-20.
//

import Foundation
 
/// This endpoint closes an open listening session. Optionally provide sync data to update the session before closing it.
public struct CloseOpenSession: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .post

        public let path: String
        
        public let queryItems: [String: String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        /// Close Open Session Parameters
        ///
        /// - Parameters:
        ///   - sessionID: The ID of the listening session.
        ///   - currentTime: The current time (in seconds) of the playback position.
        ///   - timeListened: The amount of time (in seconds) the user has spent listening since the last session sync.
        ///   - duration: The total duration (in seconds) of the playing item.
        public init(
            sessionID: String,
            currentTime: Float? = nil,
            timeListened: Float? = nil,
            duration: Float? = nil
        ) throws {
            self.path = "/api/session/\(sessionID)/close"
            
            var body: [String: String] = [:]
            body.setIfPresent("currentTime", currentTime?.description)
            body.setIfPresent("timeListened", timeListened?.description)
            body.setIfPresent("duration", duration?.description)
            self.body = try JSONEncoder().encode(body)
        }
        
    }
    
    // MARK: Response
    
    public typealias Response = String
    
    public enum AudiobookshelfError: Error {
        
        case notFound
        
    }
        
    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self),
        
        /// No listening session with the provided ID is open, or the session belongs to another user.
        404: .failure(AudiobookshelfError.notFound)
        
    ]
    
}
