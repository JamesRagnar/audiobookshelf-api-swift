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

    private func encode(_ value: some Encodable) throws -> [String: Any] {
        let data = try JSONEncoder().encode(value)
        return try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])
    }

}
