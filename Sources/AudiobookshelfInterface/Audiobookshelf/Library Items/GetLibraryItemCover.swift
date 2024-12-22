//
//  GetLibraryItemCover.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-20.
//

import Foundation


import UIKit

/// This endpoint retrieves a library item's cover image.
public struct GetLibraryItemCover: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public enum Format: String {
            
            case webp
            
            case jpeg
            
        }
        
        public let method: RequestMethod = .get

        public let path: String
        
        public let queryItems: [String : String]?
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer
        
        /// Get Library Item Cover Parameters
        ///
        /// - Parameters:
        ///   - itemID: The ID of the library item.
        ///   - width: The requested width of the cover image.
        ///   - height: The requested height of the cover image. If null, the image is scaled proportionately.
        ///   - format: The requested format of the image. The default value depends on the request headers.
        ///   - raw: Whether to get the raw cover image file instead of a scaled version.
        public init(
            itemID: String,
            width: Int? = nil,
            height: Int? = nil,
            format: Format? = nil,
            raw: Bool? = nil
        ) {
            self.path = "/api/items/\(itemID)/cover"
            
            var queryItems: [String: String] = [:]
            queryItems.setIfPresent("width", width?.description)
            queryItems.setIfPresent("height", height?.description)
            queryItems.setIfPresent("format", format?.rawValue)
            queryItems.setIfPresent("raw", raw?.binaryString)
            self.queryItems = queryItems
        }
        
    }
    
    // MARK: Response
    
    public enum AudiobookshelfError: Error {
        
        case notFound
        
        case internalServerError
        
    }
    
    public typealias Response = Data
    
    public static let responseCases: ResponseCases = [
        
        /// Success
        200: .success(Response.self),
        
        /// Either no library item exists with the given ID, or the item does not have a cover.
        404: .failure(AudiobookshelfError.notFound),
        
        /// There was an error when attempting to read the cover file.
        500: .failure(AudiobookshelfError.internalServerError),
        
    ]
    
}
