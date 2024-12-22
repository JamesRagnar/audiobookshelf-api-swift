//
//  GetPersonalizedLibrary.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-22.
//

import AudiobookshelfModel
import Foundation

/// This endpoint returns a library's personalized view for home page display.
public struct GetPersonalizedLibrary: Interface {
    
    // MARK: Request
    
    public struct Parameters: RequestParameters {
        
        public enum Include: String {
            
            case rssfeed
            
        }
        
        public let method: RequestMethod = .get

        public let path: String
        
        public let queryItems: [String : String]?
        
        public let headers: [String : String]? = nil
        
        public let body: Data? = nil
        
        public let authentication: AuthenticationType = .bearer

        /// Get Personalized Library Parameters
        ///
        /// - Parameters:
        ///   - libraryID: The ID of the library.
        ///   - limit: Limit the number of items in each 'shelf' of the response.
        ///   - include: A comma separated list of what to include with the library items.
        public init(
            libraryID: String,
            limit: Int? = nil,
            include: Set<Include>? = nil
        ) {
            self.path = "/api/libraries/\(libraryID)/personalized"
            
            var queryItems: [String: String] = [:]
            queryItems.setIfPresent("limit", limit?.description)
            queryItems.setIfPresent("include", include?.joined())
            self.queryItems = queryItems
        }
        
    }
    
    // MARK: Response
    
    public typealias Response = [Shelf]
    
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

public extension GetPersonalizedLibrary {
    
    struct Shelf: Decodable, Sendable {
        
        /// The ID of the shelf.
        public let id: String

        /// The label of the shelf.
        public let label: String
        
        /// The label string key of the shelf, for internationalization purposes.
        public let labelStringKey: String
        
        /// The type of items the shelf represents.
        public let type: ShelfType
        
        /// The entities to be displayed on the shelf.
        public let entities: [Entity]
        
        /// The category of the shelf.
        public let category: String?
        
        enum CodingKeys: CodingKey {
            case id
            case label
            case labelStringKey
            case type
            case entities
            case category
        }
        
        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(String.self, forKey: .id)
            self.label = try container.decode(String.self, forKey: .label)
            self.labelStringKey = try container.decode(String.self, forKey: .labelStringKey)
            self.type = try container.decode(ShelfType.self, forKey: .type)
            self.category = try container.decodeIfPresent(String.self, forKey: .category)
            
            switch type {
            case .book, .podcast, .episode:
                let libraryItems = try container.decode([LibraryItem].self, forKey: .entities)
                self.entities = libraryItems.map { .libraryItem($0) }
            case .series:
                let libraryItems = try container.decode([Series].self, forKey: .entities)
                self.entities = libraryItems.map { .series($0) }
            case .authors:
                let libraryItems = try container.decode([Author].self, forKey: .entities)
                self.entities = libraryItems.map { .author($0) }
            }
        }
    }
    
    enum Entity: Decodable, Sendable {
        
        var id: String {
            switch self {
            case .libraryItem(let item):
                return item.id
            case .series(let series):
                return series.id
            case .author(let author):
                return author.id
            }
        }
        
        case libraryItem(LibraryItem)
        
        case series(Series)
        
        case author(Author)
        
    }

    enum ShelfType: String, Decodable, Sendable {
        
        case book
        
        case series
        
        case authors
        
        case episode
        
        case podcast

    }

}
