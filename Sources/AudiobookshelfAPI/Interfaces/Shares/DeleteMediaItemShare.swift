//
//  DeleteMediaItemShare.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Delete a media item share.
public struct DeleteMediaItemShare: Interface {

    // MARK: Request

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        /// Delete Media Item Share Request
        ///
        /// - Parameters:
        ///   - shareId: The ID of the share to delete.
        public init(shareId: String) {
            self.path = "/api/share/mediaitem/\(shareId)"
        }

    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

        case notFound

        case internalError

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(204),
        failures: [
            .code(403, .error(AudiobookshelfError.forbidden)),
            .code(404, .error(AudiobookshelfError.notFound)),
            .code(500, .error(AudiobookshelfError.internalError))
        ]
    )

}
