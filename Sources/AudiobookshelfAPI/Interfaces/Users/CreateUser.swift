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

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil

        public typealias Body = Payload

        public let body: Body?

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

    public typealias Response = User

    public enum AudiobookshelfError: Error {

        case badRequest

        case forbidden

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        403: .failure(AudiobookshelfError.forbidden),

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
