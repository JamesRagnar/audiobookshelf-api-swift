//
//  GetSeries.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-21.
//

import AudiobookshelfModel
import Foundation

/// This endpoint retrieves a series.
public struct GetSeries: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public enum Include: String {
            
            case progress
            
            case rssFeed

        }
        
        public let method: RequestMethod = .get

        public let path: String
        
        public let queryItems: [String : String]?
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil

        public let authentication: AuthenticationType = .bearer

        /// Get Series Parameters
        ///
        /// - Parameters:
        ///   - seriesID: The ID of the series.
        ///   - include: A comma separated list of what to include with the series.
        public init(
            seriesID: String,
            include: Set<Include>? = nil
        ) {
            path = "/api/series/\(seriesID)"
            
            var queryItems: [String: String] = [:]
            queryItems.setIfPresent("include", include?.joined())
            self.queryItems = queryItems
        }
        
    }
    
    // MARK: Response
    
    public typealias Response = Series
    
    public enum AudiobookshelfError: Error {
        
        case notFound
        
    }
        
    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self),
        
        /// No series with provided ID exists.
        404: .failure(AudiobookshelfError.notFound)
        
    ]
    
}
