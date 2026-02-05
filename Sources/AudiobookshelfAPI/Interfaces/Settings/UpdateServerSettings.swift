//
//  UpdateServerSettings.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2026-01-28.
//

import Foundation
import RagnarNetworking

/// Update server settings.
public struct UpdateServerSettings: Interface {

    // MARK: Request

    public struct Parameters: RequestParameters {

        public let method: RequestMethod = .patch

        public let path: String = "/api/settings"

        public let queryItems: [String: String?]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = ServerSettingsUpdate

        public let body: Body?

        public let authentication: AuthenticationType = .bearer

        /// Update Server Settings Parameters.
        public init(settings: Body) {
            self.body = settings
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable {

        public let serverSettings: ServerSettings

    }

    public enum AudiobookshelfError: Error {

        case badRequest

        case forbidden

    }

    public static let responseCases: ResponseCases = [

        200: .success(Response.self),

        400: .failure(AudiobookshelfError.badRequest),

        403: .failure(AudiobookshelfError.forbidden)

    ]

}

public extension UpdateServerSettings.Parameters {

    /// Update payload for `/api/settings`.
    struct ServerSettingsUpdate: RequestBody, Encodable, Sendable {

        public enum ScheduleValue: Encodable, Sendable, Equatable {
            case cron(String)
            case disabled

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                case .cron(let value):
                    try container.encode(value)
                case .disabled:
                    try container.encode(false)
                }
            }
        }

        public var scannerParseSubtitle: Bool?
        public var scannerFindCovers: Bool?
        public var scannerCoverProvider: String?
        public var scannerPreferMatchedMetadata: Bool?
        public var scannerDisableWatcher: Bool?

        public var storeCoverWithItem: Bool?
        public var storeMetadataWithItem: Bool?
        public var metadataFileFormat: String?

        public var rateLimitLoginRequests: Int?
        public var rateLimitLoginWindow: Int?
        public var allowIframe: Bool?

        public var backupPath: String?
        public var backupSchedule: ScheduleValue?
        public var backupsToKeep: Int?
        public var maxBackupSize: Int?

        public var loggerDailyLogsToKeep: Int?
        public var loggerScannerLogsToKeep: Int?

        public var homeBookshelfView: Int?
        public var bookshelfView: Int?

        public var podcastEpisodeSchedule: String?

        public var sortingIgnorePrefix: Bool?

        public var chromecastEnabled: Bool?
        public var dateFormat: String?
        public var timeFormat: String?
        public var language: String?
        public var allowedOrigins: [String]?
        public var logLevel: Int?

        public init(
            scannerParseSubtitle: Bool? = nil,
            scannerFindCovers: Bool? = nil,
            scannerCoverProvider: String? = nil,
            scannerPreferMatchedMetadata: Bool? = nil,
            scannerDisableWatcher: Bool? = nil,
            storeCoverWithItem: Bool? = nil,
            storeMetadataWithItem: Bool? = nil,
            metadataFileFormat: String? = nil,
            rateLimitLoginRequests: Int? = nil,
            rateLimitLoginWindow: Int? = nil,
            allowIframe: Bool? = nil,
            backupPath: String? = nil,
            backupSchedule: ScheduleValue? = nil,
            backupsToKeep: Int? = nil,
            maxBackupSize: Int? = nil,
            loggerDailyLogsToKeep: Int? = nil,
            loggerScannerLogsToKeep: Int? = nil,
            homeBookshelfView: Int? = nil,
            bookshelfView: Int? = nil,
            podcastEpisodeSchedule: String? = nil,
            sortingIgnorePrefix: Bool? = nil,
            chromecastEnabled: Bool? = nil,
            dateFormat: String? = nil,
            timeFormat: String? = nil,
            language: String? = nil,
            allowedOrigins: [String]? = nil,
            logLevel: Int? = nil
        ) {
            self.scannerParseSubtitle = scannerParseSubtitle
            self.scannerFindCovers = scannerFindCovers
            self.scannerCoverProvider = scannerCoverProvider
            self.scannerPreferMatchedMetadata = scannerPreferMatchedMetadata
            self.scannerDisableWatcher = scannerDisableWatcher
            self.storeCoverWithItem = storeCoverWithItem
            self.storeMetadataWithItem = storeMetadataWithItem
            self.metadataFileFormat = metadataFileFormat
            self.rateLimitLoginRequests = rateLimitLoginRequests
            self.rateLimitLoginWindow = rateLimitLoginWindow
            self.allowIframe = allowIframe
            self.backupPath = backupPath
            self.backupSchedule = backupSchedule
            self.backupsToKeep = backupsToKeep
            self.maxBackupSize = maxBackupSize
            self.loggerDailyLogsToKeep = loggerDailyLogsToKeep
            self.loggerScannerLogsToKeep = loggerScannerLogsToKeep
            self.homeBookshelfView = homeBookshelfView
            self.bookshelfView = bookshelfView
            self.podcastEpisodeSchedule = podcastEpisodeSchedule
            self.sortingIgnorePrefix = sortingIgnorePrefix
            self.chromecastEnabled = chromecastEnabled
            self.dateFormat = dateFormat
            self.timeFormat = timeFormat
            self.language = language
            self.allowedOrigins = allowedOrigins
            self.logLevel = logLevel
        }
    }

}
