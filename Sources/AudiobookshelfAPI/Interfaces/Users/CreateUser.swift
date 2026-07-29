//
//  CreateUser.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Create a new user.
public struct CreateUser: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/users"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body

        public let authentication: AuthenticationType = .bearer

        public init(
            username: String,
            password: String,
            type: User.UserType,
            isActive: Bool = true,
            librariesAccessible: [String]? = nil,
            permissions: UserPermissions? = nil
        ) {
            self.body = Payload(
                username: username,
                password: password,
                type: type,
                isActive: isActive,
                librariesAccessible: librariesAccessible,
                permissions: permissions
            )
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        /// The newly created user.
        public let user: User

    }

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

        /// The user could not be saved.
        case internalServerError

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(403, .error(AudiobookshelfError.forbidden)),
        .code(500, .error(AudiobookshelfError.internalServerError))
    ]

}

public extension CreateUser.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let username: String

        let password: String

        let type: User.UserType

        let isActive: Bool

        let librariesAccessible: [String]?

        let permissions: UserPermissions?

    }

}
