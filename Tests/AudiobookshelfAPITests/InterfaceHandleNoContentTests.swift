@testable import AudiobookshelfAPI
import Foundation
import RagnarNetworking
import Testing

@Suite
struct InterfaceHandleNoContentTests {

    @Test
    func noContentInterfacesDecodeEmptyDataOn200() {
        expectNoContentHandle(PurgeCacheAll.self)
        expectNoContentHandle(PurgeItemsCache.self)
        expectNoContentHandle(SendTestEmail.self)
        expectNoContentHandle(UpdateNotificationSettings.self)
        expectNoContentHandle(ValidateCronExpression.self)
        expectNoContentHandle(DeleteSession.self)
    }

    private func expectNoContentHandle<T: Interface>(_ interface: T.Type) {
        let response = makeResponse(statusCode: 200)

        do {
            let decoded = try interface.handle((data: Data(), response: response))
            if let data = decoded as? Data {
                #expect(data.isEmpty)
            } else {
                #expect(Bool(false))
            }
        } catch {
            #expect(Bool(false))
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
