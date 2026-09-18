import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct UpdateServerSettingsTests {

    @Test
    func requestOmitsUnsetSettings() throws {
        let request = UpdateServerSettings.Request(
            settings: .init(language: "en")
        )
        let object = try encode(request.body)

        #expect(request.path == "/api/settings")
        #expect(object.keys.sorted() == ["language"])
        #expect(object["language"] as? String == "en")
    }

    @Test
    func schedulesEncodeCronAndDisabledValues() throws {
        let cron = try encode(
            UpdateServerSettings.Request.ServerSettingsUpdate(
                backupSchedule: .cron("0 0 * * *")
            )
        )
        let disabled = try encode(
            UpdateServerSettings.Request.ServerSettingsUpdate(
                backupSchedule: .disabled
            )
        )

        #expect(cron["backupSchedule"] as? String == "0 0 * * *")
        #expect(disabled["backupSchedule"] as? Bool == false)
    }

    @Test
    func allowedSettingsRetainExplicitFalseZeroAndEmptyValues() throws {
        let settings = UpdateServerSettings.Request.ServerSettingsUpdate(
            scannerParseSubtitle: false,
            scannerFindCovers: false,
            scannerCoverProvider: "google",
            scannerPreferMatchedMetadata: false,
            scannerDisableWatcher: false,
            storeCoverWithItem: false,
            storeMetadataWithItem: false,
            allowIframe: false,
            backupSchedule: .disabled,
            backupsToKeep: 0,
            maxBackupSize: 0,
            homeBookshelfView: 0,
            bookshelfView: 0,
            sortingIgnorePrefix: false,
            chromecastEnabled: false,
            dateFormat: "",
            timeFormat: "",
            language: "",
            allowedOrigins: [],
            logLevel: 0
        )
        let object = try encode(settings)

        #expect(object.count == 20)
        #expect(object["backupSchedule"] as? Bool == false)
        #expect(object["allowedOrigins"] is [Any])
        #expect(object["logLevel"] as? Int == 0)
        #expect(object["scannerParseSubtitle"] as? Bool == false)
    }

    @Test
    func legacySettingsRemainEncodedForOlderServers() throws {
        let object = try encode(UpdateServerSettings.Request.ServerSettingsUpdate(
            metadataFileFormat: "abs",
            rateLimitLoginRequests: 5,
            rateLimitLoginWindow: 60,
            backupPath: "/backups",
            loggerDailyLogsToKeep: 7,
            loggerScannerLogsToKeep: 8,
            podcastEpisodeSchedule: "0 * * * *"
        ))

        #expect(object["metadataFileFormat"] as? String == "abs")
        #expect(object["rateLimitLoginRequests"] as? Int == 5)
        #expect(object["rateLimitLoginWindow"] as? Int == 60)
        #expect(object["backupPath"] as? String == "/backups")
        #expect(object["loggerDailyLogsToKeep"] as? Int == 7)
        #expect(object["loggerScannerLogsToKeep"] as? Int == 8)
        #expect(object["podcastEpisodeSchedule"] as? String == "0 * * * *")
    }

    private func encode(_ value: some Encodable) throws -> [String: Any] {
        let data = try JSONEncoder().encode(value)
        return try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])
    }

}
