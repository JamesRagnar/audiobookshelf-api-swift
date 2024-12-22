//
//  Healthcheck.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-21.
//

import Foundation

/// This endpoint is a simple check to see if the server is operating and can respond.
public struct Healthcheck: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .get

        public let path: String = "/healthcheck"
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .none

        /// Healthcheck Parameters
        public init() {}
        
    }
    
    // MARK: Response
    
    public typealias Response = String

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),
        
    ]
    
}
