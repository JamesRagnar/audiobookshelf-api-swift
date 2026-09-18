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

    public struct Request: InterfaceRequest {

        public let method: RequestMethod = .patch

        public let path: String = "/api/settings"

        public let queryItems: [URLQueryItem]? = nil

        public let headers: [String: String]? = nil

        public typealias Body = ServerSettingsUpdate

        public let body: Body

        public let authentication: AuthenticationScheme? = .bearer

        /// Update Server Settings Request.
        public init(settings: Body) {
            self.body = settings
        }

    }

    // MARK: Response

    public struct Response: Decodable, Sendable, InterfaceResponse {

        public let serverSettings: ServerSettings

    }

    public enum AudiobookshelfError: Error, Sendable {

        case badRequest

        case forbidden

    }

    public static let responses = ResponseContract<Response>(
        success: .exact(200),
        failures: [
            .code(400, .error(AudiobookshelfError.badRequest)),
            .code(403, .error(AudiobookshelfError.forbidden))
        ]
    )

}

public extension UpdateServerSettings.Request {

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
        private var metadataFileFormatValue: String?
        private var rateLimitLoginRequestsValue: Int?
        private var rateLimitLoginWindowValue: Int?
        public var allowIframe: Bool?

        private var backupPathValue: String?
        public var backupSchedule: ScheduleValue?
        public var backupsToKeep: Int?
        public var maxBackupSize: Int?

        private var loggerDailyLogsToKeepValue: Int?
        private var loggerScannerLogsToKeepValue: Int?

        public var homeBookshelfView: Int?
        public var bookshelfView: Int?

        private var podcastEpisodeScheduleValue: String?

        public var sortingIgnorePrefix: Bool?

        public var chromecastEnabled: Bool?
        public var dateFormat: String?
        public var timeFormat: String?
        public var language: String?
        public var allowedOrigins: [String]?
        public var logLevel: Int?

        @available(*, deprecated, message: "Audiobookshelf v2.36.1 and later ignore metadataFileFormat.")
        public var metadataFileFormat: String? {
            get { metadataFileFormatValue }
            set { metadataFileFormatValue = newValue }
        }

        @available(*, deprecated, message: "Audiobookshelf v2.36.1 and later ignore rateLimitLoginRequests.")
        public var rateLimitLoginRequests: Int? {
            get { rateLimitLoginRequestsValue }
            set { rateLimitLoginRequestsValue = newValue }
        }

        @available(*, deprecated, message: "Audiobookshelf v2.36.1 and later ignore rateLimitLoginWindow.")
        public var rateLimitLoginWindow: Int? {
            get { rateLimitLoginWindowValue }
            set { rateLimitLoginWindowValue = newValue }
        }

        @available(*, deprecated, message: "Audiobookshelf v2.36.1 and later ignore backupPath.")
        public var backupPath: String? {
            get { backupPathValue }
            set { backupPathValue = newValue }
        }

        @available(*, deprecated, message: "Audiobookshelf v2.36.1 and later ignore loggerDailyLogsToKeep.")
        public var loggerDailyLogsToKeep: Int? {
            get { loggerDailyLogsToKeepValue }
            set { loggerDailyLogsToKeepValue = newValue }
        }

        @available(*, deprecated, message: "Audiobookshelf v2.36.1 and later ignore loggerScannerLogsToKeep.")
        public var loggerScannerLogsToKeep: Int? {
            get { loggerScannerLogsToKeepValue }
            set { loggerScannerLogsToKeepValue = newValue }
        }

        @available(*, deprecated, message: "Audiobookshelf v2.36.1 and later ignore podcastEpisodeSchedule.")
        public var podcastEpisodeSchedule: String? {
            get { podcastEpisodeScheduleValue }
            set { podcastEpisodeScheduleValue = newValue }
        }

        private enum CodingKeys: String, CodingKey {
            case scannerParseSubtitle
            case scannerFindCovers
            case scannerCoverProvider
            case scannerPreferMatchedMetadata
            case scannerDisableWatcher
            case storeCoverWithItem
            case storeMetadataWithItem
            case metadataFileFormat
            case rateLimitLoginRequests
            case rateLimitLoginWindow
            case allowIframe
            case backupPath
            case backupSchedule
            case backupsToKeep
            case maxBackupSize
            case loggerDailyLogsToKeep
            case loggerScannerLogsToKeep
            case homeBookshelfView
            case bookshelfView
            case podcastEpisodeSchedule
            case sortingIgnorePrefix
            case chromecastEnabled
            case dateFormat
            case timeFormat
            case language
            case allowedOrigins
            case logLevel
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(scannerParseSubtitle, forKey: .scannerParseSubtitle)
            try container.encodeIfPresent(scannerFindCovers, forKey: .scannerFindCovers)
            try container.encodeIfPresent(scannerCoverProvider, forKey: .scannerCoverProvider)
            try container.encodeIfPresent(scannerPreferMatchedMetadata, forKey: .scannerPreferMatchedMetadata)
            try container.encodeIfPresent(scannerDisableWatcher, forKey: .scannerDisableWatcher)
            try container.encodeIfPresent(storeCoverWithItem, forKey: .storeCoverWithItem)
            try container.encodeIfPresent(storeMetadataWithItem, forKey: .storeMetadataWithItem)
            try container.encodeIfPresent(metadataFileFormatValue, forKey: .metadataFileFormat)
            try container.encodeIfPresent(rateLimitLoginRequestsValue, forKey: .rateLimitLoginRequests)
            try container.encodeIfPresent(rateLimitLoginWindowValue, forKey: .rateLimitLoginWindow)
            try container.encodeIfPresent(allowIframe, forKey: .allowIframe)
            try container.encodeIfPresent(backupPathValue, forKey: .backupPath)
            try container.encodeIfPresent(backupSchedule, forKey: .backupSchedule)
            try container.encodeIfPresent(backupsToKeep, forKey: .backupsToKeep)
            try container.encodeIfPresent(maxBackupSize, forKey: .maxBackupSize)
            try container.encodeIfPresent(loggerDailyLogsToKeepValue, forKey: .loggerDailyLogsToKeep)
            try container.encodeIfPresent(loggerScannerLogsToKeepValue, forKey: .loggerScannerLogsToKeep)
            try container.encodeIfPresent(homeBookshelfView, forKey: .homeBookshelfView)
            try container.encodeIfPresent(bookshelfView, forKey: .bookshelfView)
            try container.encodeIfPresent(podcastEpisodeScheduleValue, forKey: .podcastEpisodeSchedule)
            try container.encodeIfPresent(sortingIgnorePrefix, forKey: .sortingIgnorePrefix)
            try container.encodeIfPresent(chromecastEnabled, forKey: .chromecastEnabled)
            try container.encodeIfPresent(dateFormat, forKey: .dateFormat)
            try container.encodeIfPresent(timeFormat, forKey: .timeFormat)
            try container.encodeIfPresent(language, forKey: .language)
            try container.encodeIfPresent(allowedOrigins, forKey: .allowedOrigins)
            try container.encodeIfPresent(logLevel, forKey: .logLevel)
        }

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
            self.metadataFileFormatValue = metadataFileFormat
            self.rateLimitLoginRequestsValue = rateLimitLoginRequests
            self.rateLimitLoginWindowValue = rateLimitLoginWindow
            self.allowIframe = allowIframe
            self.backupPathValue = backupPath
            self.backupSchedule = backupSchedule
            self.backupsToKeep = backupsToKeep
            self.maxBackupSize = maxBackupSize
            self.loggerDailyLogsToKeepValue = loggerDailyLogsToKeep
            self.loggerScannerLogsToKeepValue = loggerScannerLogsToKeep
            self.homeBookshelfView = homeBookshelfView
            self.bookshelfView = bookshelfView
            self.podcastEpisodeScheduleValue = podcastEpisodeSchedule
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
