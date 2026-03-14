@testable import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

@Suite
struct InterfaceErrorMappingTests {

    @Test
    func sendTestEmailMapsKnownErrors() {
        let badRequest = captureResponseError(
            for: SendTestEmail.self,
            statusCode: 400
        )
        #expect(badRequest?.statusCode == 400)

        let forbidden = captureResponseError(
            for: SendTestEmail.self,
            statusCode: 403
        )
        #expect(forbidden?.statusCode == 403)
    }

    @Test
    func validateCronExpressionMapsBadRequest() {
        let badRequest = captureResponseError(
            for: ValidateCronExpression.self,
            statusCode: 400,
            body: Data("Invalid cron expression".utf8)
        )
        #expect(badRequest?.statusCode == 400)
    }

    @Test
    func updateNotificationSettingsMapsForbidden() {
        let forbidden = captureResponseError(
            for: UpdateNotificationSettings.self,
            statusCode: 403
        )
        #expect(forbidden?.statusCode == 403)
    }

    @Test
    func getSearchProvidersMapsNotFoundForPre231Servers() {
        let notFound = captureResponseError(
            for: GetSearchProviders.self,
            statusCode: 404
        )
        #expect(notFound?.statusCode == 404)
    }

    private func captureResponseError<T: Interface>(
        for interface: T.Type,
        statusCode: Int,
        body: Data = Data()
    ) -> ResponseError? {
        let response = makeResponse(statusCode: statusCode)

        do {
            _ = try interface.handle((data: body, response: response))
            return nil
        } catch let error {
            return error
        }
    }

    private func makeResponse(statusCode: Int) -> URLResponse {
        HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }

}
