//
//  CheckServerStatus.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-20.
//

import Foundation

/// This endpoint reports the server's initialization status.
public struct CheckServerStatus: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .get

        public let path: String = "/status"
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .none

        /// Check Server Status Parameters
        public init() {}
        
    }
    
    // MARK: Response
    
    public struct Response: Decodable, Sendable {
        
        /// Whether the server has been initialized.
        public let isInit: Bool
        
        /// The server's default language.
        public let language: String
        
        /// The server's config path. Will only exist if `isInit` is false.
        public let ConfigPath: String?
        
        /// The server's metadata path. Will only exist if `isInit` is false.
        public let MetadataPath: String?
        
    }
        
    public static let responseCases: ResponseCases = [

        200: .success(Response.self),
        
    ]
    
}
