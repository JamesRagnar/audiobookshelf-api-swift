@testable import AudiobookshelfAPI
import Testing

@Suite
struct ServerCompatibilityTests {

    // MARK: Supported

    @Test(arguments: ["2.26.0", "2.26.9", "2.30.0", "2.33.0", "2.33.2", "2.34.0", "2.34.99", "2.35.0", "2.35.1",
                      "2.35.99"])
    func supportedVersionsReturnSupported(version: String) {
        #expect(ServerCompatibility.evaluate(serverVersion: version) == .supported)
    }

    @Test(arguments: ["2.26.0", "2.35.1"])
    func isSupportedReturnsTrueForSupportedVersions(version: String) {
        #expect(ServerCompatibility.isSupported(serverVersion: version) == true)
    }

    // MARK: Below minimum

    @Test(arguments: ["2.25.9", "2.25.0", "2.0.0", "1.9.9", "0.0.1"])
    func belowMinimumVersionsReturnBelowMinimum(version: String) {
        #expect(ServerCompatibility.evaluate(serverVersion: version) == .belowMinimum)
    }

    @Test(arguments: ["2.25.9", "1.0.0"])
    func isSupportedReturnsFalseForBelowMinimum(version: String) {
        #expect(ServerCompatibility.isSupported(serverVersion: version) == false)
    }

    // MARK: Above tested range

    @Test(arguments: ["2.36.0", "3.0.0", "10.0.0"])
    func aboveTestedRangeVersionsReturnAboveTestedRange(version: String) {
        #expect(ServerCompatibility.evaluate(serverVersion: version) == .aboveTestedRange)
    }

    @Test(arguments: ["2.36.0", "3.0.0"])
    func isSupportedReturnsFalseForAboveTestedRange(version: String) {
        #expect(ServerCompatibility.isSupported(serverVersion: version) == false)
    }

    // MARK: Unknown format

    @Test(arguments: ["", "abc", "2.33", "2.33.x", "not-a-version", "2.33.0.0", "v2.33.0", "2.33.0-beta.1"])
    func unrecognizedStringsReturnUnknownVersionFormat(version: String) {
        #expect(ServerCompatibility.evaluate(serverVersion: version) == .unknownVersionFormat)
    }

    @Test
    func isSupportedReturnsFalseForUnknownFormat() {
        #expect(ServerCompatibility.isSupported(serverVersion: "not-a-version") == false)
    }

}
