//
//  AuthorizeUser.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-24.
//

import Foundation
import RagnarNetworking

/// Authorize a user with OpenID authentication.
public struct AuthorizeUser: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .post

        public let path: String = "/api/authorize"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = Payload

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        public init(code: String, state: String) {
            self.body = Payload(code: code, state: state)
        }

    }

    // MARK: Response

    public typealias Response = User

    public enum AudiobookshelfError: Error, Sendable {

        case unauthorized

        case badRequest

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(400, .error(AudiobookshelfError.badRequest)),
        .code(401, .error(AudiobookshelfError.unauthorized))
    ]

}

public extension AuthorizeUser.Parameters {

    struct Payload: RequestBody, Encodable, Sendable {

        let code: String

        let state: String

    }

}
