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

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        /// Delete Media Item Share Parameters
        ///
        /// - Parameters:
        ///   - shareId: The ID of the share to delete.
        public init(shareId: String) {
            self.path = "/api/share/mediaitem/\(shareId)"
        }

    }

    // MARK: Response

    public typealias Response = Data

    public enum AudiobookshelfError: Error {

        case forbidden

        case notFound

        case internalError

    }

    public static let responseCases: ResponseCases = [

        204: .success(Response.self),

        403: .failure(AudiobookshelfError.forbidden),

        404: .failure(AudiobookshelfError.notFound),

        500: .failure(AudiobookshelfError.internalError)

    ]

}
