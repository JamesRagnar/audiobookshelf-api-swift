//
//  GetYourUser.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-21.
//

import AudiobookshelfModel
import Foundation

/// This endpoint retrieves your user.
public struct GetYourUser: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .get

        public let path: String = "/api/me"
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer

        /// Get Your User Parameters
        public init() {}
        
    }
    
    // MARK: Response
    
    public typealias Response = User
        
    public static let responseCases: ResponseCases = [

        200: .success(Response.self),
        
    ]
    
}
