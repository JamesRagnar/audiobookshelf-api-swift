//
//  GetLibraryNarrators.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2025-12-27.
//


import Foundation
import RagnarNetworking

/// This endpoint returns a library's narrators.
public struct GetLibraryNarrators: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data? = nil

        public let authentication: AuthenticationType = .bearer

        /// Get Library Narrators Parameters
        ///
        /// - Parameter libraryID: The ID of the library.
        public init(
            libraryID: String
        ) {
            self.path = "/api/libraries/\(libraryID)/narrators"
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let narrators: [Narrator]

    }

    public static let responseCases: ResponseCases = [

        /// The requested narrators.
        200: .success(Response.self),

    ]

}

public extension GetLibraryNarrators {

    struct Narrator: Decodable, Sendable, Identifiable {

        public let id: String

        public let name: String

        public let numBooks: Int

    }

}

