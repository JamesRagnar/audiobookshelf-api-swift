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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Update Library Narrator Request
        ///
        /// - Parameters:
        ///   - libraryId: The ID of the library.
        ///   - narratorName: The current narrator name.
        ///   - newName: The new narrator name.
        public init(
            libraryId: String,
            narratorName: String,
            newName: String
        ) {
            let encodedNarrator = Data(narratorName.utf8)
                .base64EncodedString()
                .addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
            self.path = "/api/libraries/\(libraryId)/narrators/\(encodedNarrator)"
            self.body = Payload(name: newName)
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        public let updated: Int

    }

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}

public extension UpdateLibraryNarrator.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let name: String

    }

}
