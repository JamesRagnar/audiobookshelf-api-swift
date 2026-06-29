@testable import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

@Suite
struct InterfaceHandleNoContentTests {

    @Test
    func noContentInterfacesDecodeEmptyDataOn200() throws {
        try expectNoContentHandle(PurgeCacheAll.self)
        try expectNoContentHandle(PurgeItemsCache.self)
        try expectNoContentHandle(SendTestEmail.self)
        try expectNoContentHandle(UpdateNotificationSettings.self)
        try expectNoContentHandle(ValidateCronExpression.self)
        try expectNoContentHandle(DeleteSession.self)
    }

    private func expectNoContentHandle<T: Interface>(_ interface: T.Type) throws {
        let response = try makeResponse(statusCode: 200)

        do {
            let decoded = try interface.handle((data: Data(), response: response))
            #expect(decoded is RagnarNetworking.EmptyResponse)
        } catch {
            #expect(Bool(false))
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
