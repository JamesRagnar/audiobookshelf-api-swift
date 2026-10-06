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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .get

        public let path: String = "/api/logger-data"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public let body: Body = .init()

        public let authentication: AuthenticationScheme? = .bearer

        public init() {}

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        /// Required wire currentDailyLogs on 2.26.0+; [] or exactly "" means no entries.
        public let currentDailyLogs: [LogEventObject]

        /// Legacy read-only alias; logs is not a wire key.
        @available(*, deprecated, renamed: "currentDailyLogs")
        public var logs: [LogEventObject] { currentDailyLogs }

        private enum CodingKeys: CodingKey {
            case currentDailyLogs
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let entries = try? container.decode([LogEventObject].self, forKey: .currentDailyLogs) {
                currentDailyLogs = entries
            } else {
                let fallback = try container.decode(String.self, forKey: .currentDailyLogs)
                guard fallback.isEmpty else {
                    throw DecodingError.dataCorruptedError(
                        forKey: .currentDailyLogs, in: container,
                        debugDescription: "Expected logs array or empty string."
                    )
                }
                currentDailyLogs = []
            }
        }

    }

    public enum AudiobookshelfError: Error, Sendable {

        case forbidden

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(403, .error(AudiobookshelfError.forbidden))
        ]
    )

}

public extension GetLoggerData {

    /// Legacy REST entry name; REST and socket logs share the same wire shape.
    @available(*, deprecated, renamed: "LogEventObject")
    typealias LogEntry = LogEventObject

}
