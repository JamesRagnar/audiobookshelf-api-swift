import AudiobookshelfAPI
import Foundation
import Testing

@Suite
struct AuthSessionContractTests {

    @Test
    func listDecodesPaginationAndOptionalDeviceData() throws {
        let body = Data(
            """
            {
              "total": 2,
              "numPages": 1,
              "page": 0,
              "itemsPerPage": 10,
              "sessions": [
                {
                  "id": "session-1",
                  "ipAddress": "10.0.0.5",
                  "userAgent": "Rost/1.0",
                  "deviceInfo": {
                    "osName": "iOS",
                    "osVersion": "26.0",
                    "deviceType": "mobile",
                    "model": "iPhone",
                    "vendor": "Apple"
                  },
                  "createdAt": 1737000000000,
                  "updatedAt": 1737600000000,
                  "current": true
                },
                {
                  "id": "session-2",
                  "ipAddress": null,
                  "userAgent": null,
                  "deviceInfo": null,
                  "createdAt": null,
                  "updatedAt": null,
                  "current": false
                }
              ]
            }
            """.utf8
        )

        let decoded = try GetYourAuthSessions.handle(
            (data: body, response: makeResponse())
        )

        #expect(decoded.total == 2)
        #expect(decoded.sessions.count == 2)
        #expect(decoded.sessions.first?.deviceInfo?.model == "iPhone")
        #expect(decoded.sessions.first?.deviceInfo?.browserName == nil)
        #expect(decoded.sessions.last?.deviceInfo == nil)
        #expect(decoded.sessions.last?.current == false)
    }

    @Test
    func listRequestIncludesTokenOnlyWhenProvided() {
        let withToken = GetYourAuthSessions.Request(
            itemsPerPage: 25,
            page: 2,
            refreshToken: "refresh-token-value"
        )
        let withoutToken = GetYourAuthSessions.Request(itemsPerPage: 10, page: 0)

        #expect(withToken.path == "/api/me/sessions")
        #expect(withToken.queryItems?["itemsPerPage"] == "25")
        #expect(withToken.queryItems?["page"] == "2")
        #expect(withToken.headers?["x-refresh-token"] == "refresh-token-value")
        #expect(withoutToken.headers == nil)
    }

    @Test
    func deleteRequestBuildsSessionPath() {
        let request = DeleteYourAuthSession.Request(sessionID: "session-1")
        #expect(request.path == "/api/me/sessions/session-1")
    }

    private func makeResponse() throws -> URLResponse {
        let url = try #require(URL(string: "https://example.com"))
        return try #require(HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        ))
    }

}
