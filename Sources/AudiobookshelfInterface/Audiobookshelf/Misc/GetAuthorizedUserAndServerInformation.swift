//
//  GetAuthorizedUserAndServerInformation.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-21.
//

import AudiobookshelfModel
import Foundation

/// This endpoint retrieves information about the authorized user and the server.
/// Used for logging into a client if an API token was persisted.
/// Returns the same payload as `Login`
public struct GetAuthorizedUserAndServerInformation: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .post

        public let path: String = "/api/authorize"
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer

        /// Get Authorized User and Server Information Parameters
        public init() {}
        
    }
    
    // MARK: Response
    
    public struct Response: Decodable, Sendable {
        
        /// The authenticated user.
        public let user: User
        
        /// The ID of the first library in the list the user has access to.
        public let userDefaultLibraryID: String
        
        /// The server's settings.
        public let serverSettings: ServerSettings
        
        /// The server's installation source.
        public let source: String
        
        enum CodingKeys: String, CodingKey {
            case user
            case userDefaultLibraryID = "userDefaultLibraryId"
            case serverSettings
            case source = "Source"
        }
        
    }
    
    public enum AudiobookshelfError: Error {
        
        case unauthorized
        
    }
        
    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self),
        
        /// No authorization was provided.
        401: .failure(AudiobookshelfError.unauthorized)
        
    ]
    
}
