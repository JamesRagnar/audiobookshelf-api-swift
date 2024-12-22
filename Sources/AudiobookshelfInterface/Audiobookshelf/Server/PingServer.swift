//
//  PingServer.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-20.
//

import Foundation

///
public struct PingServer: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .get

        public let path: String = "/ping"
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .none

        /// Ping Server Parameters
        public init() {}
        
    }
    
    // MARK: Response
    
    public struct Response: Decodable, Sendable {
        
        /// Will always be true.
        public let success: Bool
        
    }
        
    public static let responseCases: ResponseCases = [

        200: .success(Response.self),
        
    ]
    
}
