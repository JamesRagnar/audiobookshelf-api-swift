//
//  DeleteUser.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Delete a user.
public struct DeleteUser: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .delete

        public let path: String

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public let body: RequestBody? = nil

        public let authentication: AuthenticationType = .bearer

        /// Delete User Parameters
        ///
        /// - Parameter userId: The ID of the user to delete.
        public init(userId: String) {
            self.path = "/api/users/\(userId)"
        }

    }

    // MARK: Response

    public typealias Response = Data

    public enum AudiobookshelfError: Error {

        case forbidden

        case notFound

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        403: .failure(AudiobookshelfError.forbidden),

        404: .failure(AudiobookshelfError.notFound),

    ]

}
