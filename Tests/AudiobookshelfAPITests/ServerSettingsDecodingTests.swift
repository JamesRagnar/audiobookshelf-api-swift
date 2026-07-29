import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct ServerSettingsDecodingTests {

    @Test
    func decodesStringSchedulesAndStringBuildNumber() throws {
        let settings = try decode(serverSettingsJSON(
            backupSchedule: #""0 0 * * *""#,
            podcastEpisodeSchedule: #""0 * * * *""#,
            buildNumber: #""2024.1""#
        ))

        #expect(settings.backupSchedule == "0 0 * * *")
        #expect(settings.podcastEpisodeSchedule == "0 * * * *")
        #expect(settings.buildNumber == "2024.1")
    }

    @Test
    func decodesDisabledSchedulesAndIntegerBuildNumber() throws {
        let settings = try decode(serverSettingsJSON(
            backupSchedule: "false",
            podcastEpisodeSchedule: "false",
            buildNumber: "42"
        ))

        #expect(settings.backupSchedule == nil)
        #expect(settings.podcastEpisodeSchedule == nil)
        #expect(settings.buildNumber == "42")
    }

    @Test
    func decodesPublicClientSettingsWithoutSensitiveOIDCFields() throws {
        let settings = try decode(serverSettingsJSON(
            backupSchedule: "false",
            podcastEpisodeSchedule: "false",
            buildNumber: "null"
        ))

        #expect(settings.authOpenIDIssuerURL == nil)
        #expect(settings.allowedOrigins == nil)
        #expect(settings.allowIframe == nil)
        #expect(settings.authOpenIDSubfolderForRedirectURLs == nil)
    }

    @Test
    func publicResponseModelDoesNotExpectSensitiveOIDCFields() throws {
        let sensitiveFieldsJSON = """
        {
          "id": "settings-1",
          "scannerFindCovers": true,
          "scannerCoverProvider": "google",
          "scannerParseSubtitle": false,
          "scannerPreferMatchedMetadata": true,
          "scannerDisableWatcher": false,
          "storeCoverWithItem": false,
          "storeMetadataWithItem": true,
          "metadataFileFormat": "json",
          "rateLimitLoginRequests": 5,
          "rateLimitLoginWindow": 60000,
          "backupsToKeep": 3,
          "maxBackupSize": 2,
          "loggerDailyLogsToKeep": 7,
          "loggerScannerLogsToKeep": 10,
          "homeBookshelfView": 1,
          "bookshelfView": 0,
          "sortingIgnorePrefix": true,
          "sortingPrefixes": ["the", "a"],
          "chromecastEnabled": true,
          "dateFormat": "yyyy-MM-dd",
          "timeFormat": "HH:mm",
          "language": "en",
          "logLevel": 2,
          "version": "2.33.0",
          "backupSchedule": false,
          "podcastEpisodeSchedule": false,
          "buildNumber": null,
          "authOpenIDClientID": "should-be-ignored",
          "authOpenIDClientSecret": "should-be-ignored",
          "authOpenIDMobileRedirectURIs": ["should-be-ignored"],
          "authOpenIDGroupClaim": "should-be-ignored",
          "authOpenIDAdvancedPermsClaim": "should-be-ignored"
        }
        """

        let settings = try decode(sensitiveFieldsJSON)

        #expect(settings.id == "settings-1")
        #expect(settings.version == "2.33.0")
    }

    @Test
    func decodesTimeZoneFrom236Servers() throws {
        let settings = try decode(serverSettingsJSON(
            backupSchedule: "false",
            podcastEpisodeSchedule: "false",
            buildNumber: "null",
            timeZone: "America/New_York"
        ))

        #expect(settings.timeZone == "America/New_York")
    }

    @Test
    func timeZoneRemainsNilOnPre236Servers() throws {
        let settings = try decode(serverSettingsJSON(
            backupSchedule: "false",
            podcastEpisodeSchedule: "false",
            buildNumber: "null"
        ))

        #expect(settings.timeZone == nil)
    }

    private func decode(_ json: String) throws -> ServerSettings {
        try JSONDecoder().decode(ServerSettings.self, from: Data(json.utf8))
    }

    private func serverSettingsJSON(
        backupSchedule: String,
        podcastEpisodeSchedule: String,
        buildNumber: String,
        timeZone: String? = nil
    ) -> String {
        let timeZoneEntry = timeZone.map { ",\n          \"timeZone\": \"\($0)\"" } ?? ""

        return """
        {
          "id": "settings-1",
          "scannerFindCovers": true,
          "scannerCoverProvider": "google",
          "scannerParseSubtitle": false,
          "scannerPreferMatchedMetadata": true,
          "scannerDisableWatcher": false,
          "storeCoverWithItem": false,
          "storeMetadataWithItem": true,
          "metadataFileFormat": "json",
          "rateLimitLoginRequests": 5,
          "rateLimitLoginWindow": 60000,
          "backupsToKeep": 3,
          "maxBackupSize": 2,
          "loggerDailyLogsToKeep": 7,
          "loggerScannerLogsToKeep": 10,
          "homeBookshelfView": 1,
          "bookshelfView": 0,
          "sortingIgnorePrefix": true,
          "sortingPrefixes": ["the", "a"],
          "chromecastEnabled": true,
          "dateFormat": "yyyy-MM-dd",
          "timeFormat": "HH:mm",
          "language": "en",
          "logLevel": 2,
          "version": "2.33.0",
          "backupSchedule": \(backupSchedule),
          "podcastEpisodeSchedule": \(podcastEpisodeSchedule),
          "buildNumber": \(buildNumber)\(timeZoneEntry)
        }
        """
    }
}
