//
//  GetAuthorImage.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

/// This endpoint retrieves an author's image.
public struct GetAuthorImage: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public enum Format: String {
            
            case webp
            
            case jpeg
            
        }
        
        struct Auth {
            let id: String
            let name: String
            
            var imageResource: ImageResource {
                .author(id)
            }
        }
        
        enum ImageResource {
            case libraryItem(String)
            case author(String)
        }
        
        public let method: RequestMethod = .get

        public let path: String
        
        public let queryItems: [String : String]?
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer
        
        /// Get Author Image Parameters
        /// 
        /// - Parameters:
        ///   - authorID: The ID of the author.
        ///   - width: The requested width of the image.
        ///   - height: The requested height of the image. If null the image is scaled proportionately.
        ///   - format: The requested format of the image. The default value depends on the request headers.
        ///   - raw: Whether to get the raw cover image file instead of a scaled version.
        public init(
            authorID: String,
            width: Int? = nil,
            height: Int? = nil,
            format: Format? = nil,
            raw: Bool? = nil
        ) {
            self.path = "/api/authors/\(authorID)/image"
            
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
        
        /// No author with provided ID exists, or the author does not have an image.
        404: .failure(AudiobookshelfError.notFound),
        
        /// There was an error when attempting to read the image file.
        500: .failure(AudiobookshelfError.internalServerError),
        
    ]
    
}
