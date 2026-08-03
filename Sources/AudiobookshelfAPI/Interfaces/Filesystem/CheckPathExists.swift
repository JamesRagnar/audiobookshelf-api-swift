//
//  CheckPathExists.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Check if a directory path exists within a library folder.
public struct CheckPathExists: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .post

        public let path: String = "/api/filesystem/pathexists"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Check Path Exists Request
        ///
        /// - Parameters:
        ///   - directory: The relative path to check.
        ///   - folderPath: The library folder path.
        public init(
            directory: String,
            folderPath: String
        ) {
            self.body = Payload(directory: directory, folderPath: folderPath)
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        public let exists: Bool

        public let libraryItemTitle: String?

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

public extension CheckPathExists.Request {

    struct Payload: RequestBody, Encodable, Sendable {

        let directory: String

        let folderPath: String

    }

}
