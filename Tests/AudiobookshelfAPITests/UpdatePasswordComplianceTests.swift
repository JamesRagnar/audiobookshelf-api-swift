import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

/// `PATCH /api/me/password` answers with two different 200 bodies depending on whether the server
/// kept the calling session alive. These cover both, and the boundary between "no rotation" and a
/// genuinely malformed body.
@Suite
struct UpdatePasswordComplianceTests {

    @Test
    func updatePasswordDecodesRotatedTokens() throws {
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

        let decoded = try UpdatePassword.handle(
            (data: body, response: makeResponse(statusCode: 200))
        )

        #expect(decoded.success == true)
        #expect(decoded.user?.accessToken == "new-access-token")
        #expect(decoded.user?.refreshToken == "new-refresh-token")
    }

    @Test
    func updatePasswordSendsRefreshTokenHeaderWhenProvided() {
        let parameters = UpdatePassword.Parameters(
            currentPassword: "old",
            newPassword: "new",
            refreshToken: "refresh-token-value"
        )

        #expect(parameters.path == "/api/me/password")
        #expect(parameters.headers?["x-refresh-token"] == "refresh-token-value")
    }

    @Test
    func updatePasswordOmitsRefreshTokenHeaderByDefault() {
        let parameters = UpdatePassword.Parameters(currentPassword: "old", newPassword: "new")

        #expect(parameters.headers?["x-refresh-token"] == nil)
    }

    @Test(arguments: [400, 403])
    func updatePasswordMapsErrorStatusCodes(statusCode: Int) throws {
        try assertMappedError(UpdatePassword.self, statusCode: statusCode)
    }

    @Test(arguments: ["OK", ""])
    func updatePasswordTreatsNonJSON200AsUnrotated(body: String) throws {
        // The server answers `sendStatus(200)` when it destroyed every session instead of rotating,
        // which is the plain-text status message rather than JSON. Pre-2.36 servers always take this
        // path; 2.36 takes it when the refresh token no longer matches a live session.
        let decoded = try UpdatePassword.handle(
            (data: Data(body.utf8), response: makeResponse(statusCode: 200))
        )

        #expect(decoded.success == true)
        #expect(decoded.user == nil)
    }

    @Test
    func updatePasswordStillFailsOnMalformedJSON200() {
        // A JSON body that does not match the contract must keep surfacing as a decoding error
        // rather than being swallowed as "no rotation".
        #expect(throws: ResponseError.self) {
            try UpdatePassword.handle(
                (data: Data(#"{"success": true, "user": {"accessToken": 12}}"#.utf8),
                 response: makeResponse(statusCode: 200))
            )
        }
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
