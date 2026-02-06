//
//  RemoveLibraryNarrator.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Remove a narrator from a library.
public struct RemoveLibraryNarrator: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Remove Library Narrator Parameters
        ///
        /// - Parameters:
        ///   - libraryId: The ID of the library.
        ///   - narratorName: The narrator name to remove.
        public init(libraryId: String, narratorName: String) {
            let encodedNarrator = Data(narratorName.utf8)
                .base64EncodedString()
                .addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
            self.path = "/api/libraries/\(libraryId)/narrators/\(encodedNarrator)"
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let updated: Int

    }

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(404, .error(AudiobookshelfError.notFound)),
    ]

}
