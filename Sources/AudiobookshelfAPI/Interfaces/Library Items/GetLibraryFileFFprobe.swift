//
//  GetLibraryFileFFprobe.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Get FFprobe data for an audio file.
public struct GetLibraryFileFFprobe: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        public init(itemId: String, fileId: String) {
            self.path = "/api/items/\(itemId)/ffprobe/\(fileId)"
        }

    }

    // MARK: Response

    public typealias Response = JSONValue

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}
