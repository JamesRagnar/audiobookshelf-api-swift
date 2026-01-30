//
//  ServerSettings.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public struct ServerSettings {
    
    /// The ID of the server settings.
    public let id: String
    
    /// Whether the scanner will attempt to find a cover if your audiobook does not have an embedded cover or a cover image inside the folder. Note: This will extend scan time.
    public let scannerFindCovers: Bool
    
    /// If scannerFindCovers is true, which metadata provider to use. See Metadata Providers for options.
    public let scannerCoverProvider: String
    
    /// Whether to extract subtitles from audiobook folder names. Subtitles must be separated by -, i.e. /audiobooks/Book Title - A Subtitle Here/ has the subtitle A Subtitle Here.
    public let scannerParseSubtitle: Bool
    
    /// Whether matched data will override item details when using Quick Match. By default, Quick Match will only fill in missing details.
    public let scannerPreferMatchedMetadata: Bool
    
    /// Whether to disable the automatic adding/updating of items when file changes are detected. Requires server restart for changes to take effect.
    public let scannerDisableWatcher: Bool
    
    /// Whether to store covers in the library item's folder. By default, covers are stored in /metadata/items. Only one file named cover will be kept.
    public let storeCoverWithItem: Bool
    
    /// Whether to store metadata files in the library item's folder. By default, metadata files are stored in /metadata/items. Uses the .abs file extension.
    public let storeMetadataWithItem: Bool
    
    /// Must be either json or abs
    public let metadataFileFormat: String
    
    /// The maximum number of login requests per rateLimitLoginWindow.
    public let rateLimitLoginRequests: Int
    
    /// The length (in ms) of each login rate limit window.
    public let rateLimitLoginWindow: Int

    /// The active authentication methods enabled on the server.
    public let authActiveAuthMethods: [String]?

    /// Custom message displayed on the login page.
    public let authLoginCustomMessage: String?

    /// OpenID Connect issuer URL.
    public let authOpenIDIssuerURL: String?

    /// OpenID Connect authorization URL.
    public let authOpenIDAuthorizationURL: String?

    /// OpenID Connect token URL.
    public let authOpenIDTokenURL: String?

    /// OpenID Connect user info URL.
    public let authOpenIDUserinfoURL: String?

    /// OpenID Connect JWKS URL.
    public let authOpenIDJwksURL: String?

    /// OpenID Connect logout URL.
    public let authOpenIDLogoutURL: String?

    /// OpenID Connect client ID.
    public let authOpenIDClientID: String?

    /// OpenID Connect client secret.
    public let authOpenIDClientSecret: String?

    /// Token signing algorithm for OpenID Connect (e.g., RS256).
    public let authOpenIDTokenSigningAlgorithm: String?

    /// OpenID Connect button text.
    public let authOpenIDButtonText: String?

    /// Whether OpenID authentication should auto-launch.
    public let authOpenIDAutoLaunch: Bool?

    /// Whether OpenID should auto-register new users.
    public let authOpenIDAutoRegister: Bool?

    /// Field to match existing users by for OpenID authentication.
    public let authOpenIDMatchExistingBy: String?

    /// Mobile redirect URIs for OpenID Connect.
    public let authOpenIDMobileRedirectURIs: [String]?

    /// OpenID Connect group claim for role mapping.
    public let authOpenIDGroupClaim: String?

    /// OpenID Connect advanced permissions claim.
    public let authOpenIDAdvancedPermsClaim: String?

    /// The cron expression for when to do automatic backups.
    public let backupSchedule: String?

    /// The maximum number of days to keep backups.
    public let backupMaxKeepDays: Int?

    /// The number of backups to keep.
    public let backupsToKeep: Int

    /// The maximum backup size (in GB) before they fail, a safeguard against misconfiguration.
    public let maxBackupSize: Int
    
    /// The number of daily logs to keep.
    public let loggerDailyLogsToKeep: Int
    
    /// The number of scanner logs to keep.
    public let loggerScannerLogsToKeep: Int
    
    /// Whether the home page should use a skeuomorphic design with wooden shelves.
    public let homeBookshelfView: Int
    
    /// Whether other bookshelf pages should use a skeuomorphic design with wooden shelves.
    public let bookshelfView: Int

    /// The cron expression for automatic podcast episode checks (e.g., "0 * * * *" for hourly).
    public let podcastEpisodeSchedule: String?

    /// Whether to ignore prefixes when sorting. For example, for the prefix the, the book title The Book Title would sort as Book Title, The.
    public let sortingIgnorePrefix: Bool
    
    /// If sortingIgnorePrefix is true, what prefixes to ignore.
    public let sortingPrefixes: [String]
    
    /// Whether to enable streaming to Chromecast devices.
    public let chromecastEnabled: Bool
    
    /// What date format to use. Options are MM/dd/yyyy, dd/MM/yyyy, dd.MM.yyyy, yyyy-MM-dd, MMM do, yyyy, MMMM do, yyyy, dd MMM yyyy, or dd MMMM yyyy.
    public let dateFormat: String
    
    /// What time format to use. Options are HH:mm (24-hour) and h:mma (am/pm).
    public let timeFormat: String
    
    /// The default server language.
    public let language: String

    /// Allowed CORS origins for the server.
    public let allowedOrigins: [String]?

    /// What log level the server should use when logging. 1 for debug, 2 for info, or 3 for warnings.
    public let logLevel: Int
    
    /// The server's version.
    public let version: String
    
}

extension ServerSettings: Decodable {}
extension ServerSettings: Sendable {}
