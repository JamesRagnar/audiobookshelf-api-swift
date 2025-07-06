//
//  GetLibraryStats.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-22.
//

import Foundation

/// This endpoint returns a library's stats.
public struct GetLibraryStats: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public let method: RequestMethod = .get

        public let path: String
        
        public let queryItems: [String : String]? = nil
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer

        /// Get Library Stats Parameters
        ///
        /// - Parameter libraryID: The ID of the library.
        public init(libraryID: String) {
            self.path = "/api/libraries\(libraryID)/stats"
        }
        
    }
    
    // MARK: Response
    
    public struct Response: Decodable, Sendable {
        
        /// The total amount of library items in the library.
        public let totalItems: Int
        
        /// The total amount of authors in the library.
        public let totalAuthors: Int
        
        /// The total amount of genres in the library.
        public let totalGenres: Int
        
        /// The total duration (in seconds) of all items in the library.
        public let totalDuration: Float
        
        /// The items with the longest durations in the library.
        public let longestItems: [LibraryItemDurationStats]
        
        /// The total number of audio tracks in the library.
        public let numAudioTrack: Int
        
        /// The total size (in bytes) of all items in the library.
        public let totalSize: Int
        
        /// The items with the largest size in the library.
        public let largestItems: [LibraryItemSizeStats]
        
        /// The authors in the library.
        public let authorsWithCount: [AuthorStats]
        
        /// The genres in the library.
        public let genresWithCount: [GenreStats]
        
    }
    
    public enum AudiobookshelfError: Error {
        
        case notFound
        
    }
        
    public static let responseCases: ResponseCases = [

        /// Success
        200: .success(Response.self),
        
        /// The user cannot access the library, or no library with the provided ID exists.
        404: .failure(AudiobookshelfError.notFound)
        
    ]
    
}

public extension GetLibraryStats.Response {
    
    struct LibraryItemDurationStats: Decodable, Sendable {
        
        /// The ID of the library item.
        public let id: String
        
        /// The title of the library item.
        public let title: String
        
        /// The duration (in seconds) of the library item.
        public let duration: Float

    }
    
    struct LibraryItemSizeStats: Decodable, Sendable {
        
        /// The ID of the library item.
        public let id: String
        
        /// The title of the library item.
        public let title: String
        
        /// The size (in bytes) of the library item.
        public let size: Int
        
    }
    
    struct AuthorStats: Decodable, Sendable {
        
        /// The ID of the author.
        public let id: String
        
        /// The title of the author.
        public let name: String
        
        /// The number of books by the author in the library.
        public let count: Int

    }
    
    struct GenreStats: Decodable, Sendable {
        
        /// The name of the genre.
        public let genre: String
        
        /// The number of items in the library with the genre.
        public let count: Int

    }

}
