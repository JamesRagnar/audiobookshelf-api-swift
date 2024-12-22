//
//  Login.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-19.
//

import AudiobookshelfModel
import Foundation

/// This endpoint logs in a client to the server, returning information about the user and server.
/// The`Authorize` endpoint is also available if an API token was persisted.
public struct Login: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .post

        public let path: String = "/login"
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data?
        
        public let authentication: AuthenticationType = .none
        
        /// Login Parameters
        ///
        /// - Parameters:
        ///   - username: The username to log in with.
        ///   - password: The password of the user.
        public init(
            username: String,
            password: String
        ) throws {
            self.body = try JSONEncoder().encode(
                [
                    "username": username,
                    "password": password
                ]
            )
        }
        
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
        
        /// Invalid username or password.
        401: .failure(AudiobookshelfError.unauthorized)
        
    ]
    
}
