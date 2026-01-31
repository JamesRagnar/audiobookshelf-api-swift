//
//  UpdateLibraryNarrator.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Update a narrator's metadata in a library.
public struct UpdateLibraryNarrator: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        /// Update Library Narrator Parameters
        ///
        /// - Parameters:
        ///   - libraryId: The ID of the library.
        ///   - narratorName: The current narrator name.
        ///   - newName: The new narrator name.
        public init(
            libraryId: String,
            narratorName: String,
            newName: String
        ) throws {
            let encodedNarrator = Data(narratorName.utf8)
                .base64EncodedString()
                .addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
            self.path = "/api/libraries/\(libraryId)/narrators/\(encodedNarrator)"
            self.body = try JSONEncoder().encode(
                Body(name: newName)
            )
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let updated: Int

    }

    public enum AudiobookshelfError: Error {

        case badRequest

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        403: .failure(AudiobookshelfError.forbidden),

        404: .failure(AudiobookshelfError.notFound),

    ]

}

public extension UpdateLibraryNarrator.Parameters {

    struct Body: Encodable {

        let name: String

    }

}
