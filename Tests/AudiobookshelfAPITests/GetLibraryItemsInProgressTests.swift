import AudiobookshelfAPI
import Testing

@Suite
struct GetLibraryItemsInProgressTests {

    @Test
    func requestEncodesLimitWithoutPage() {
        let request = GetLibraryItemsInProgress.Request(limit: 0)

        #expect(request.queryItems?["limit"] == "0")
        #expect(request.queryItems?["page"] == nil)
    }

}
