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

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationType = .bearer

        /// Update Password Parameters
        ///
        /// - Parameters:
        ///   - currentPassword: The user's current password.
        ///   - newPassword: The new password to set.
        public init(
            currentPassword: String?,
            newPassword: String?
        ) {
            self.body = Payload(password: currentPassword, newPassword: newPassword)
        }
    }

    // MARK: Response

    public typealias Response = EmptyResponse

    public enum AudiobookshelfError: Error, Sendable {
        case badRequest
        case forbidden
    }

    public static let responseCases: ResponseMap = [
        .code(200, .noContent),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden))
    ]
}

public extension UpdatePassword.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {
        let password: String?
        let newPassword: String?
    }
}
