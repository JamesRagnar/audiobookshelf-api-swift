//
//  RemoveMediaProgress.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2025-02-24.
//

import Foundation
import RagnarNetworking

/// This endpoint removes a media progress entry from your user.
public struct RemoveMediaProgress: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .delete

        public let path: String
        
        public let queryItems: [String : String?]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: RequestBody? = nil
        
        public let authentication: AuthenticationType = .bearer
        
        /// Remove Media Progress Parameters
        ///
        /// - Parameter mediaProgressID: The ID of the media progress to remove.
        public init(
            mediaProgressID: String
        ) {
            self.path = "/api/me/progress/\(mediaProgressID)"
        }
        
    }
    
    // MARK: Response
    
    public typealias Response = String
        
    public static let responseCases: ResponseCases = [

        200: .success(Response.self),
        
    ]
    
}
