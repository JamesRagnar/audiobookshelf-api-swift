@testable import AudiobookshelfAPI
import RagnarNetworking
import Testing

/// `ResponseContract` no longer distinguishes a no-body success from any other success; both are
/// `.success`, and it is the declared `Response` type (`EmptyResponse`, here) that builds itself
/// from zero bytes. This suite only checks that 200 is declared as a successful status for these
/// endpoints. `InterfaceHandleNoContentTests` covers the actual empty-body decoding behavior.
@Suite
struct InterfaceResponseCasesTests {

    @Test
    func emptyResponseInterfacesDeclare200AsSuccess() {
        expectSuccessCase(PurgeCacheAll.self)
        expectSuccessCase(PurgeItemsCache.self)
        expectSuccessCase(SendTestEmail.self)
        expectSuccessCase(UpdateNotificationSettings.self)
        expectSuccessCase(ValidateCronExpression.self)
        expectSuccessCase(DeleteSession.self)
    }

    private func expectSuccessCase<T: Interface>(_ interface: T.Type) {
        let match = interface.responses.match(200)
        #expect(match != nil)

        let isSuccess: Bool
        if let match {
            switch match {
            case .success:
                isSuccess = true

            case .failure:
                isSuccess = false
            }
        } else {
            isSuccess = false
        }

        #expect(isSuccess)
    }

}
