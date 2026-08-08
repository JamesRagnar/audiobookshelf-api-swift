import AudiobookshelfAPI
import Testing

@Suite
struct LogoutRequestTests {

    @Test
    func defaultRequestOmitsAllDevices() {
        let request = Logout.Request(refreshToken: "refresh-token-value")

        #expect(request.queryItems == nil)
        #expect(request.headers?["x-refresh-token"] == "refresh-token-value")
    }

    @Test
    func allDevicesRequestEncodesFlag() {
        let request = Logout.Request(refreshToken: "refresh-token-value", allDevices: true)
        #expect(request.queryItems?["allDevices"] == "1")
    }

}
