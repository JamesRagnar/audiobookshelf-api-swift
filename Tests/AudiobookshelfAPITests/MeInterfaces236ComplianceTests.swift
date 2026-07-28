import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

@Suite
struct MeInterfaces236ComplianceTests {

    // MARK: Auth Sessions

    @Test
    func getYourAuthSessionsDecodesPaginatedSessions() throws {
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
                  "userAgent": "Rost/1.0 (iPhone; iOS 26.0)",
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
            (data: body, response: makeResponse(statusCode: 200))
        )

        #expect(decoded.total == 2)
        #expect(decoded.numPages == 1)
        #expect(decoded.page == 0)
        #expect(decoded.itemsPerPage == 10)
        #expect(decoded.sessions.count == 2)

        let current = try #require(decoded.sessions.first)
        #expect(current.id == "session-1")
        #expect(current.ipAddress == "10.0.0.5")
        #expect(current.current == true)
        #expect(current.deviceInfo?.osName == "iOS")
        #expect(current.deviceInfo?.model == "iPhone")
        // The server omits keys it could not parse rather than sending null
        #expect(current.deviceInfo?.browserName == nil)
        #expect(current.createdAt == 1737000000000)

        let other = try #require(decoded.sessions.last)
        #expect(other.deviceInfo == nil)
        #expect(other.userAgent == nil)
        #expect(other.updatedAt == nil)
        #expect(other.current == false)
    }

    @Test
    func getYourAuthSessionsSendsRefreshTokenHeaderOnlyWhenProvided() {
        let withToken = GetYourAuthSessions.Parameters(
            itemsPerPage: 25,
            page: 2,
            refreshToken: "refresh-token-value"
        )

        #expect(withToken.path == "/api/me/sessions")
        #expect(withToken.queryItems?["itemsPerPage"] == "25")
        #expect(withToken.queryItems?["page"] == "2")
        #expect(withToken.headers?["x-refresh-token"] == "refresh-token-value")

        let withoutToken = GetYourAuthSessions.Parameters(itemsPerPage: 10, page: 0)

        #expect(withoutToken.headers == nil)
    }

    @Test(arguments: [400, 403, 404])
    func deleteYourAuthSessionMapsErrorStatusCodes(statusCode: Int) throws {
        try assertMappedError(DeleteYourAuthSession.self, statusCode: statusCode)
    }

    @Test
    func deleteYourAuthSessionBuildsPathAndTreats200AsNoContent() throws {
        let parameters = DeleteYourAuthSession.Parameters(sessionID: "session-1")
        #expect(parameters.path == "/api/me/sessions/session-1")

        _ = try DeleteYourAuthSession.handle(
            (data: Data(), response: makeResponse(statusCode: 200))
        )
    }

    // MARK: Progress and Bookmarks

    @Test
    func getAllMediaProgressDecodesWrappedArray() throws {
        let body = Data(
            """
            {
              "mediaProgress": [
                {
                  "id": "progress-1",
                  "userId": "user-1",
                  "libraryItemId": "library-item-1",
                  "mediaItemId": "media-item-1",
                  "mediaItemType": "book",
                  "duration": 3600,
                  "progress": 0.25,
                  "currentTime": 900,
                  "isFinished": false,
                  "hideFromContinueListening": false,
                  "lastUpdate": 1737600000000,
                  "startedAt": 1737000000000
                }
              ]
            }
            """.utf8
        )

        let decoded = try GetAllMediaProgress.handle(
            (data: body, response: makeResponse(statusCode: 200))
        )

        #expect(decoded.mediaProgress.count == 1)
        #expect(decoded.mediaProgress.first?.libraryItemId == "library-item-1")
        #expect(GetAllMediaProgress.Parameters().path == "/api/me/progress")
    }

    @Test
    func getYourBookmarksDecodesWrappedArray() throws {
        let decoded = try GetYourBookmarks.handle(
            (data: bookmarksJSON, response: makeResponse(statusCode: 200))
        )

        #expect(decoded.bookmarks.count == 1)
        #expect(decoded.bookmarks.first?.title == "Chapter 3")
        #expect(GetYourBookmarks.Parameters().path == "/api/me/bookmarks")
    }

    @Test
    func getYourBookmarksForLibraryItemBuildsPathAndDecodes() throws {
        let parameters = GetYourBookmarksForLibraryItem.Parameters(libraryItemID: "library-item-1")
        #expect(parameters.path == "/api/me/bookmarks/library-item-1")

        let decoded = try GetYourBookmarksForLibraryItem.handle(
            (data: bookmarksJSON, response: makeResponse(statusCode: 200))
        )

        #expect(decoded.bookmarks.first?.libraryItemId == "library-item-1")
    }

    @Test(arguments: [403, 404])
    func getYourBookmarksForLibraryItemMapsAccessAndNotFound(statusCode: Int) throws {
        try assertMappedError(GetYourBookmarksForLibraryItem.self, statusCode: statusCode)
    }

    // MARK: Password

    @Test
    func updatePasswordWithTokenRotationDecodesRotatedTokens() throws {
        let body = Data(
            """
            {
              "success": true,
              "user": {
                "accessToken": "new-access-token",
                "refreshToken": "new-refresh-token"
              }
            }
            """.utf8
        )

        let decoded = try UpdatePasswordWithTokenRotation.handle(
            (data: body, response: makeResponse(statusCode: 200))
        )

        #expect(decoded.success == true)
        #expect(decoded.user.accessToken == "new-access-token")
        #expect(decoded.user.refreshToken == "new-refresh-token")
    }

    @Test
    func updatePasswordWithTokenRotationSendsRefreshTokenHeader() {
        let parameters = UpdatePasswordWithTokenRotation.Parameters(
            currentPassword: "old",
            newPassword: "new",
            refreshToken: "refresh-token-value"
        )

        #expect(parameters.path == "/api/me/password")
        #expect(parameters.headers?["x-refresh-token"] == "refresh-token-value")
    }

    @Test(arguments: [400, 403])
    func updatePasswordWithTokenRotationMapsErrorStatusCodes(statusCode: Int) throws {
        try assertMappedError(UpdatePasswordWithTokenRotation.self, statusCode: statusCode)
    }

    @Test
    func updatePasswordStillTreats200AsNoContent() throws {
        // Without the x-refresh-token header the server responds with an empty body on every
        // supported version, so the pre-2.36 interface stays usable.
        _ = try UpdatePassword.handle(
            (data: Data(), response: makeResponse(statusCode: 200))
        )
    }

    // MARK: Logout

    @Test
    func logoutOmitsAllDevicesQueryItemByDefault() {
        let parameters = Logout.Parameters(refreshToken: "refresh-token-value")

        #expect(parameters.queryItems == nil)
        #expect(parameters.headers?["x-refresh-token"] == "refresh-token-value")
    }

    @Test
    func logoutSendsAllDevicesQueryItemWhenRequested() {
        let parameters = Logout.Parameters(refreshToken: "refresh-token-value", allDevices: true)

        #expect(parameters.queryItems?["allDevices"] == "1")
    }

    // MARK: Helpers

    private var bookmarksJSON: Data {
        Data(
            """
            {
              "bookmarks": [
                {
                  "libraryItemId": "library-item-1",
                  "title": "Chapter 3",
                  "time": 1234.5,
                  "createdAt": 1737600000000
                }
              ]
            }
            """.utf8
        )
    }

    private func assertMappedError<T: Interface>(
        _ interface: T.Type,
        statusCode: Int,
        body: Data = Data()
    ) throws {
        let error = try captureResponseError(for: interface, statusCode: statusCode, body: body)
        #expect(error?.statusCode == statusCode)
    }

    private func captureResponseError<T: Interface>(
        for interface: T.Type,
        statusCode: Int,
        body: Data = Data()
    ) throws -> ResponseError? {
        let response = try makeResponse(statusCode: statusCode)
        do {
            _ = try interface.handle((data: body, response: response))
            return nil
        } catch let error {
            return error
        }
    }

    private func makeResponse(statusCode: Int) throws -> URLResponse {
        let url = try #require(URL(string: "https://example.com"))
        return try #require(HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        ))
    }

}
