@testable import AudiobookshelfAPI
import RagnarNetworking
import Testing

@Suite
struct InterfaceResponseCasesTests {

    @Test
    func emptyResponseInterfacesUseNoContentFor200() {
        expectNoContentCase(PurgeCacheAll.self)
        expectNoContentCase(PurgeItemsCache.self)
        expectNoContentCase(SendTestEmail.self)
        expectNoContentCase(UpdateNotificationSettings.self)
        expectNoContentCase(ValidateCronExpression.self)
        expectNoContentCase(DeleteSession.self)
    }

    private func expectNoContentCase<T: Interface>(_ interface: T.Type) {
        let outcome = interface.responseCases.match(200)
        #expect(outcome != nil)

        let isNoContent: Bool
        if let outcome {
            switch outcome {
            case .noContent:
                isNoContent = true
            default:
                isNoContent = false
            }
        } else {
            isNoContent = false
        }

        #expect(isNoContent)
    }

}
