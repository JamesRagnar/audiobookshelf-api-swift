//
//  CheckServerStatus.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-20.
//

import Foundation
import RagnarNetworking

/// This endpoint reports the server's initialization status.
public struct CheckServerStatus: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/status"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .none

        /// Check Server Status Parameters
        public init() {}

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        /// Whether the server has been initialized.
        public let isInit: Bool

        /// The server's default language.
        public let language: String

        /// The server's config path. Will only exist if `isInit` is false.
        public let configPath: String?

        /// The server's metadata path. Will only exist if `isInit` is false.
        public let metadataPath: String?

        private enum CodingKeys: String, CodingKey {
            case isInit
            case language
            case configPath = "ConfigPath"
            case metadataPath = "MetadataPath"
        }

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode)
    ]

}
