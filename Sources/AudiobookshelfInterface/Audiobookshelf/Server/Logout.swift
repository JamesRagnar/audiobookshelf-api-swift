//
//  Logout.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

/// This endpoint logs out a client from the server.
/// If the socketId parameter is provided, the server removes the socket from the client list.
/// When using a socket connection this allows a client to change the user without needing to re-create the socket connection.
public struct Logout: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .post

        public let path: String = "/logout"
        
        public let queryItems: [String : String]?
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer

        /// Logout Parameters
        ///
        /// - Parameter socketID: The ID of the connected socket.
        public init(socketID: String? = nil) {
            var queryItems: [String: String] = [:]
            queryItems.setIfPresent("socketId", socketID)
            self.queryItems = queryItems
        }
        
    }
    
    // MARK: Response
    
    public typealias Response = String

    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self)

    ]
    
}
