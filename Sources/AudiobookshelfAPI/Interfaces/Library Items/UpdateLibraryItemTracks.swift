//
//  UpdateLibraryItemTracks.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Update audio tracks for a library item.
public struct UpdateLibraryItemTracks: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Book-only complete audio-file replacement on 2.26.0+.
        /// - Parameters:
        ///   - itemId: Required library-item ID.
        ///   - orderedFileData: Nonempty list of existing audio-file inodes. Include every file
        ///     to retain. Included files receive 1-based indices; excluded files receive -1.
        public init(itemId: String, orderedFileData: [OrderedFileData]) {
            self.path = "/api/items/\(itemId)/tracks"
            self.body = Payload(orderedFileData: orderedFileData)
        }

    }

    // MARK: Response

    public typealias Response = LibraryItem

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

public extension UpdateLibraryItemTracks.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let orderedFileData: [OrderedFileData]

    }

}

public extension UpdateLibraryItemTracks.Request {

    /// Audio-file order/exclusion write entry on 2.26.0+.
    struct OrderedFileData: Encodable, Sendable {
        /// Required wire ino belonging to an existing book audio file.
        public let ino: String
        /// Optional wire exclude; omission means false. Explicit false is transmitted.
        public let exclude: Bool?

        /// Creates an entry; nil exclude omits the key.
        public init(ino: String, exclude: Bool? = nil) {
            self.ino = ino
            self.exclude = exclude
        }
    }

}
