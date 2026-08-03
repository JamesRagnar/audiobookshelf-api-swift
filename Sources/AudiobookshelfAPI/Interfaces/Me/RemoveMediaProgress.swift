//
//  RemoveMediaProgress.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2025-02-24.
//

import Foundation
import RagnarNetworking

/// This endpoint removes a media progress entry from your user.
public struct RemoveMediaProgress: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Remove Media Progress Request
        ///
        /// - Parameter mediaProgressID: The ID of the media progress to remove.
        public init(
            mediaProgressID: String
        ) {
            self.path = "/api/me/progress/\(mediaProgressID)"
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case notFound

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(404, .error(AudiobookshelfError.notFound))
        ]
    )

}
