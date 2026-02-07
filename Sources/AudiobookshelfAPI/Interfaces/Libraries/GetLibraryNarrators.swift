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

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body? = nil

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

    public static let responseCases: ResponseMap = [

        /// The requested narrators.
        .code(200, .decode)
    ]

}

public extension GetLibraryNarrators {

    struct Response: Decodable, Sendable {

        public let narrators: [Narrator]

    }

    struct Narrator: Decodable, Sendable, Identifiable {

        public let id: String

        public let name: String

        public let numBooks: Int

    }

}
