@testable import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

@Suite
struct InterfaceErrorMappingTests {

    @Test
    func sendTestEmailMapsKnownErrors() throws {
        let badRequest = try captureResponseError(
            for: SendTestEmail.self,
            statusCode: 400
        )
        #expect(badRequest?.statusCode == 400)

        let forbidden = try captureResponseError(
            for: SendTestEmail.self,
            statusCode: 403
        )
        #expect(forbidden?.statusCode == 403)
    }

    @Test
    func validateCronExpressionMapsBadRequest() throws {
        let badRequest = try captureResponseError(
            for: ValidateCronExpression.self,
            statusCode: 400,
            body: Data("Invalid cron expression".utf8)
        )
        #expect(badRequest?.statusCode == 400)
    }

    @Test
    func updateNotificationSettingsMapsForbidden() throws {
        let forbidden = try captureResponseError(
            for: UpdateNotificationSettings.self,
            statusCode: 403
        )
        #expect(forbidden?.statusCode == 403)
    }

    @Test
    func getSearchProvidersMapsNotFoundForPre231Servers() throws {
        let notFound = try captureResponseError(
            for: GetSearchProviders.self,
            statusCode: 404
        )
        #expect(notFound?.statusCode == 404)
    }

    @Test
    func getOpenSessionMapsForbidden() throws {
        let forbidden = try captureResponseError(
            for: GetOpenSession.self,
            statusCode: 403
        )
        #expect(forbidden?.statusCode == 403)
    }

    @Test
    func syncOpenSessionMapsForbidden() throws {
        let forbidden = try captureResponseError(
            for: SyncOpenSession.self,
            statusCode: 403
        )
        #expect(forbidden?.statusCode == 403)
    }

    @Test
    func closeOpenSessionMapsForbidden() throws {
        let forbidden = try captureResponseError(
            for: CloseOpenSession.self,
            statusCode: 403
        )
        #expect(forbidden?.statusCode == 403)
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
