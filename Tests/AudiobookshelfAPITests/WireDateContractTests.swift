import AudiobookshelfAPI
import Foundation
import Testing

private typealias Fixtures = MaintainedContractFixtures

@Suite
struct WireDateContractTests {

    @Test(arguments: [
        "2026-01-01T00:00:00Zjunk", "2026-01-01T00:00:00Z\n",
        "2026-02-31T00:00:00Z", "2026-01-01T24:99:00Z", "2026-01-01T00:00:00"
    ])
    func rejectsPartialMatchesAndInvalidCalendarDates(date: String) throws {
        let json = try Fixtures.changed(Fixtures.apiKey, key: "createdAt", value: date)
        #expect(throws: (any Error).self) {
            try Fixtures.response(UpdateAPIKey.self, "{\"apiKey\":\(json)}")
        }
    }

    @Test(arguments: ["2024-02-29T05:30:00+05:30", "2024-02-29T05:30:00.000+05:30"])
    func acceptsLeapDaysAndTimezoneOffsets(date: String) throws {
        let json = try Fixtures.changed(Fixtures.apiKey, key: "createdAt", value: date)
        let response = try Fixtures.response(UpdateAPIKey.self, "{\"apiKey\":\(json)}")
        #expect(response.apiKey.createdAt.timeIntervalSince1970 == 1_709_164_800)
    }

}
