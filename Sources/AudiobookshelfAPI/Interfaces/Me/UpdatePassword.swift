//
//  UpdatePassword.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-27.
//

import Foundation
import RagnarNetworking

/// Update the authenticated user's password.
public struct UpdatePassword: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String = "/api/me/password"

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        /// Update Password Parameters
        ///
        /// - Parameters:
        ///   - currentPassword: The user's current password.
        ///   - newPassword: The new password to set.
        public init(
            currentPassword: String?,
            newPassword: String?
        ) throws {
            self.body = try JSONEncoder().encode(
                Body(password: currentPassword, newPassword: newPassword)
            )
        }
    }

    // MARK: Response

    public typealias Response = Data

    public enum AudiobookshelfError: Error {
        case badRequest
        case forbidden
    }

    public static let responseCases: ResponseCases = [
        200: .success(Response.self),
        400: .failure(AudiobookshelfError.badRequest),
        403: .failure(AudiobookshelfError.forbidden)
    ]
}

public extension UpdatePassword.Parameters {

    struct Body: Encodable {
        let password: String?
        let newPassword: String?
    }
}
