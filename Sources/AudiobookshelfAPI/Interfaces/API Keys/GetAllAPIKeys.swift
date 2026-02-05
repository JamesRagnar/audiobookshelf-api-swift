//
//  GetAllAPIKeys.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Get all API keys.
public struct GetAllAPIKeys: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/api/api-keys"

        public let queryItems: [String : String?]? = nil

        public let headers: [String : String]? = nil


        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        public init() {}

    }

    // MARK: Response

    public typealias Response = APIKeys

    public enum AudiobookshelfError: Error {

        case forbidden

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        403: .failure(AudiobookshelfError.forbidden)

    ]

}

public extension GetAllAPIKeys {

    struct APIKeys: Decodable, Sendable {

        public let apiKeys: [APIKey]

    }

}
