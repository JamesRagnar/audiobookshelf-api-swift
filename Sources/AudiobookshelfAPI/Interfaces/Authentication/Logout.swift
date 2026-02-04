//
//  Logout.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation
import RagnarNetworking

/// This endpoint logs out a client from the server.
public struct Logout: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .post

        public let path: String = "/logout"
        
        public let queryItems: [String : String?]? = nil
        
        public let headers: [String : String]?
        
        public typealias Body = EmptyBody

        public let body: Body? = nil
        
        public let authentication: AuthenticationType = .none

        /// Logout Parameters
        ///
        /// - Parameter refreshToken: The JWT refresh token.
        public init(
            refreshToken: String
        ) {
            self.headers = [
                "x-refresh-token": refreshToken,
            ]
        }
        
    }
    
    // MARK: Response
    
    public struct Response: Decodable, Sendable {
        
        /// OIDC logout URL
        public let redirectURL: String?
        
        enum CodingKeys: String, CodingKey {
            case redirectURL = "redirect_url"
        }
        
    }

    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self)

    ]
    
}
