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

        public init(itemId: String, tracks: [AudioTrack]) {
            self.path = "/api/items/\(itemId)/tracks"
            self.body = Payload(tracks: tracks)
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

        let tracks: [AudioTrack]

    }

}
