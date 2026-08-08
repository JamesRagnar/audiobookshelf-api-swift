import AudiobookshelfAPI
import RagnarNetworking
import Testing

@Suite
struct InterfaceSuccessContractTests {

    @Test
    func emptyResponseInterfacesDeclareSuccessfulResponses() {
        expectSuccess(PurgeCacheAll.self, statusCode: 200)
        expectSuccess(PurgeItemsCache.self, statusCode: 200)
        expectSuccess(SendTestEmail.self, statusCode: 200)
        expectSuccess(UpdateNotificationSettings.self, statusCode: 200)
        expectSuccess(ValidateCronExpression.self, statusCode: 200)
        expectSuccess(DeleteSession.self, statusCode: 200)
    }

    @Test
    func binaryInterfacesDeclareSuccessfulResponses() {
        expectSuccess(GetHLSStreamFile.self, statusCode: 200)
        expectSuccess(GetLibraryItemCover.self, statusCode: 200)
        expectSuccess(GetLibraryItemCover.self, statusCode: 204)
        expectSuccess(GetLibraryFile.self, statusCode: 200)
        expectSuccess(GetLibraryFile.self, statusCode: 204)
        expectSuccess(GetShareCover.self, statusCode: 200)
        expectSuccess(GetShareCover.self, statusCode: 204)
    }

    private func expectSuccess<T: Interface>(_ interface: T.Type, statusCode: Int) {
        guard case .success = interface.responses.match(statusCode) else {
            Issue.record("\(interface) does not declare success status \(statusCode)")
            return
        }
    }

}
