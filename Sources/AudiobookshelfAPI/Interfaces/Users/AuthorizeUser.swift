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

        public let queryItems: [String : String]? = nil

        public let headers: [String : String]? = nil

        public let body: Data?

        public let authentication: AuthenticationType = .bearer

        public init(code: String, state: String) throws {
            self.body = try JSONEncoder().encode(
                Body(code: code, state: state)
            )
        }

    }

    // MARK: Response

    public typealias Response = User

    public enum AudiobookshelfError: Error {

        case unauthorized

        case badRequest

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        401: .failure(AudiobookshelfError.unauthorized),

    ]

}

extension AuthorizeUser.Parameters {

    struct Body: Encodable {

        let code: String

        let state: String

    }

}
