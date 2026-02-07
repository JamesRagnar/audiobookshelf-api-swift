//
//  GetLoggerData.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Get server log data for debugging.
public struct GetLoggerData: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .get

        public let path: String = "/api/logger-data"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public let body: Body? = nil

        public let authentication: AuthenticationType = .bearer

        public init() {}

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let logs: [LogEntry]

    }

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

    }

    public static let responseCases: ResponseMap = [

        .code(200, .decode),
        .code(403, .error(AudiobookshelfError.forbidden))
    ]

}

public extension GetLoggerData {

    struct LogEntry: Decodable, Sendable {

        public let timestamp: Int

        public let level: String

        public let message: String

    }

}
