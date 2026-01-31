//
//  GetLibrary.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-21.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves a library.
public struct GetLibrary: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public enum Include: String {
            case filterData = "filterdata"
        }
        
        public let method: RequestMethod = .get

        public let path: String
        
        public let queryItems: [String: String]?
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer
        
        /// Get Library Parameters
        ///
        /// - Parameters:
        ///   - libraryID: The ID of the library to retrieve.
        ///   - include: A comma separated list of what to include with the library item.
        public init(
            libraryID: String,
            include: Set<Include>?
        ) {
            self.path = "/api/libraries/\(libraryID)"
            
            var queryItems: [String: String] = [:]
            queryItems.setIfPresent("include", include?.joined())
            self.queryItems = queryItems
        }
        
    }
    
    // MARK: Response

    public struct Response: Sendable {

        /// The library object. Always present in both response modes.
        public let library: Library

        /// Filter data for the library. Only present when requested with `?include=filterdata`.
        public let filterdata: FilterData?

        /// Number of issues in the library. Only present when requested with `?include=filterdata`.
        public let issues: Int?

        /// Number of user playlists in this library. Only present when requested with `?include=filterdata`.
        public let numUserPlaylists: Int?

    }

    public enum AudiobookshelfError: Error {
        
        ///
        case notFound
        
    }
        
    public static let responseCases: ResponseCases = [

        200: .success(Response.self),
        
        404: .failure(AudiobookshelfError.notFound)
        
    ]

}

extension GetLibrary.Response: Decodable {

    enum CodingKeys: String, CodingKey {
        case library
        case filterdata
        case issues
        case numUserPlaylists
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Check if this is the expanded response with filterdata
        if container.contains(.filterdata) {
            // Mode B: Wrapper response with filterdata
            self.filterdata = try container.decode(FilterData.self, forKey: .filterdata)
            self.issues = try container.decode(Int.self, forKey: .issues)
            self.numUserPlaylists = try container.decode(Int.self, forKey: .numUserPlaylists)
            self.library = try container.decode(Library.self, forKey: .library)
        } else {
            // Mode A: Direct library response
            self.filterdata = nil
            self.issues = nil
            self.numUserPlaylists = nil
            self.library = try Library(from: decoder)
        }
    }

}
