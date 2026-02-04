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

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public typealias Body = Payload

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        public init(itemId: String, tracks: [AudioTrack]) {
            self.path = "/api/items/\(itemId)/tracks"
            self.body = Payload(tracks: tracks)
        }

    }

    // MARK: Response

    public typealias Response = LibraryItem

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

public extension UpdateLibraryItemTracks.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let tracks: [AudioTrack]

    }

}
