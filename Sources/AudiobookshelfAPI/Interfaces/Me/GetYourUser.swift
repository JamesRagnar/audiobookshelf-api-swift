//
//  GetYourUser.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-21.
//

import Foundation
import RagnarNetworking

/// This endpoint retrieves your user.
public struct GetYourUser: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/api/me"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationType = .bearer

        /// Get Your User Parameters
        public init() {}

    }

    // MARK: Response

    public typealias Response = User

    public static let responseCases: ResponseMap = [

        .code(200, .decode)
    ]

}
